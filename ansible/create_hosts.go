package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
)

// TerraformOutput represents the structure of Terraform outputs
type TerraformOutput struct {
	Sensitive bool   `json:"sensitive"`
	Type      string `json:"type"`
	Value     string `json:"value"`
}

func main() {
	// Current directory
	currentDir, err := os.Getwd()
	if err != nil {
		fmt.Println("Error getting current directory:", err)
		os.Exit(1)
	}

	// Directory where Terraform files are located relative to the ansible directory
	terraformDir := "../terraform"
	
	// Directory where Ansible files are located relative to the terraform directory
	ansibleDir := "../ansible"

	// Terraform output names
	controlNodeOutput := "control_node_public_ip"
	managedNodeOutput := "managed_node_public_ip"

	// Username and private key path for SSH connection
	ansibleSSHUser := "ec2-user"
	ansibleSSHPrivateKey := "../../../../AWS/mba-key-pair.pem"

	// Navigate to the Terraform directory
	err = os.Chdir(terraformDir)
	if err != nil {
		fmt.Println("Error changing directory:", err)
		os.Exit(1)
	}

	// Execute the 'terraform output' command and capture the output
	cmd := exec.Command("terraform", "output", "--json")
	outputJSON, err := cmd.Output()
	if err != nil {
		fmt.Println("Error running 'terraform output':", err)
		os.Exit(1)
	}

	// Decode Terraform's JSON output
	var terraformOutput map[string]TerraformOutput
	err = json.Unmarshal(outputJSON, &terraformOutput)
	if err != nil {
		fmt.Println("Error decoding JSON output:", err)
		os.Exit(1)
	}

	// Get the IPs from Terraform outputs
	controlNodeIP := terraformOutput[controlNodeOutput].Value
	managedNodeIP := terraformOutput[managedNodeOutput].Value

	// Check if the IPs were obtained
	if controlNodeIP == "" || managedNodeIP == "" {
		fmt.Println("One or more IP addresses not found.")
		os.Exit(1)
	}

	// Navigate back to the Ansible script directory
	err = os.Chdir(ansibleDir)
	if err != nil {
			fmt.Println("Error changing directory:", err)
			os.Exit(1)
	}

	// Create the Ansible inventory file
	inventoryContent := fmt.Sprintf(`[control_node]
%s ansible_ssh_user=%s ansible_ssh_private_key_file=%s

[managed_node]
%s ansible_ssh_user=%s
`, controlNodeIP, ansibleSSHUser, ansibleSSHPrivateKey, managedNodeIP, ansibleSSHUser)


	err = ioutil.WriteFile(filepath.Join(currentDir, "inventory.ini"), []byte(inventoryContent), 0644)
	if err != nil {
		fmt.Println("Error creating inventory file:", err)
		os.Exit(1)
	}

	fmt.Println("Inventory file created at", filepath.Join(currentDir, "inventory.ini"))
}
