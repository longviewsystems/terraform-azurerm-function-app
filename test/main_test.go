package main

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"log"
	"testing"
)

func TestTerraform(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixture",
		VarFiles     : []string{"./fixture/test.tfvars"},
	}

	init, err := terraform.InitE(t, terraformOptions)

	if err != nil {
		log.Println(err)
	}

	t.Log(init)

	plan, err := terraform.PlanE(t, terraformOptions)

	if err != nil {
		log.Println(err)
	}

	t.Log(plan)

	apply, err := terraform.ApplyE(t, terraformOptions)

	if err != nil {
		log.Println(err)
	}

	t.Log(apply)

	defer terraform.Destroy(t, terraformOptions)
}
