#!/bin/bash

RED="\033[0;31m"
WHITE="\033[0m"

print(){
  color=$1
  message=$2
  echo -e "${color}${message}${WHITE}"
}

# Function to load environment variables from .tfvars file
load_env_from_tfvars() {
    local tfvars_file="$1"

    # Check if the .tfvars file exists
    if [[ ! -f "${tfvars_file}" ]]; then
        print "${RED}" "Error: .tfvars file not found: ${tfvars_file}"
        exit 1
    fi

    # Read the .tfvars file and export the variables
    while IFS= read -r line; do
        # Check if the line contains an assignment
        if [[ $line =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=[[:space:]]*\"?(.*)\"?$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"

            # Remove leading/trailing whitespace from value
            value="${value#"${value%%[![:space:]]*}"}"
            value="${value%"${value##*[![:space:]]}"}"

            # Remove trailing quote if present
            value="${value%%\"}"

            # Check if the value is empty
            if ! [[ -z "${value}" ]]; then
                 # Export the variable
                export "${key}"="${value}"
            fi
        fi
    done < "${tfvars_file}"
}

configure_aws_credentials() {
  # Check if the profile already exists
    if ! aws configure get aws_access_key_id --profile "${aws_profile}" &>/dev/null; then
    # Set the AWS credentials
    aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}" --profile "${aws_profile}"
    aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}" --profile "${aws_profile}"
    aws configure set aws_region "${AWS_REGION}" --profile "${aws_profile}"
    print "${WHITE}" "AWS credentials configured successfully in the ${aws_profile} profile."
  fi
}

initialize () {
  # read env from myvars.auto.tfvars
  load_env_from_tfvars "myvars.auto.tfvars" "cache_money_cli" "aws_envs"
  # tf resources
  codepipeline_target_module="module.codepipeline"
  backend_target_module="module.apprunner"
  frontend_target_module="module.amplify"
  # aws profiles and git branches resources
  aws_profile_name="${aws_profile}"
  backend_branch="${be_branch_name}"
  frontend_branch="${fe_branch_name}"
  configure_aws_credentials
}

get_mfa_code() {
  read -p "Enter your AWS MFA code: " mfa_code
  if [[ -z "$mfa_code" ]]; then
      print "${RED}" "MFA is not provided. Please try again."
      get_mfa_code
  else
    source mfa $mfa_code $aws_profile_name
    if [ $? -ne 0 ]; then
      get_mfa_code
    fi
  fi
}

create() {
    initialize
    print "${WHITE}" "You selected Created."
    # Add your code for Option 1 here
    # Execute Terraform commands
    mfa_code="${1:-0}"
    if [[ $mfa_code -eq 0 ]]; then
      get_mfa_code
    else
      source mfa $mfa_code $aws_profile_name
      if [ $? -ne 0 ]; then
        get_mfa_code
      fi
    fi

    if ! terraform init; then
      print "${RED}" "Error: Terraform init failed."
      exit 1
    fi

    if ! terraform apply -auto-approve; then
      print "${RED}" "Error: Terraform apply for codepipeline failed."
      exit 1
    else
      if [ -n "$backend_branch" ]; then
        # Capture Amplify URL
        APP_RUNNER_URL=$(terraform output -raw be_url)
        print "${WHITE}" "BE URL: https://$APP_RUNNER_URL"
      fi
      if [ -n "$frontend_branch" ]; then
        AMPLIFY_URL=$(terraform output -raw fe_url)
        print "${WHITE}" "FE URL: https://$fe_branch_name.$AMPLIFY_URL"
      fi
    fi
}

destroy() {
      initialize
      print "${WHITE}" "You selected destroy"
      mfa_code="${1:-0}"
      if [[ $mfa_code -eq 0 ]]; then
        get_mfa_code
      else
        source mfa $mfa_code $aws_profile_name
        if [ $? -ne 0 ]; then
          get_mfa_code
        fi
      fi
      if ! terraform init; then
        echo "Error: Terraform init failed."
        exit 1
      fi
      # Add your code for Option 2 here
      print "${WHITE}" "Performing Terraform destroy for $target_module..."
      if ! terraform destroy -auto-approve; then
        print "${RED}" "Error: Terraform apply for destroy failed."
        exit 1
      fi
}

# Function to display the menu
show_menu() {
   tput setaf 6  # Set text color to cyan
  cat << "EOF"
╔═════════════════════════════════════════════════════════════════════════════════════════════════════════╗
  ______     ___       ______  __    __   _______    .___  ___.   ______   .__   __.  ___________    ____
 /      |   /   \     /      ||  |  |  | |   ____|   |   \/   |  /  __  \  |  \ |  | |   ____\   \  /   /
|  ,----'  /  ^  \   |  ,----'|  |__|  | |  |__      |  \  /  | |  |  |  | |   \|  | |  |__   \   \/   /
|  |      /  /_\  \  |  |     |   __   | |   __|     |  |\/|  | |  |  |  | |  . `  | |   __|   \_    _/
|  `----./  _____  \ |  `----.|  |  |  | |  |____    |  |  |  | |  `--'  | |  |\   | |  |____    |  |
 \______/__/     \__\ \______||__|  |__| |_______|   |__|  |__|  \______/  |__| \__| |_______|   |__|
╚═════════════════════════════════════════════════════════════════════════════════════════════════════════╝
EOF
echo "╔═════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
  tput setaf 2  # Set text color to green
  tput bold    # Set bold text
    echo " 1. Create"
    echo " 2. Destroy"
    echo " 3. Exit"
    tput setaf 6  # Set text color to cyan
    echo "╚═════════════════════════════════════════════════════════════════════════════════════════════════════════╝"

    tput sgr0  # Reset text color
}
tput setaf 2  # Set text color to green
tput bold    # Set bold text

# Function to read user input
read_option() {
    echo -n "Enter your choice: "
    read -r choice
    case $choice in
        1)
            create
            ;;
        2)
           destroy
            ;;
        3)
            print "${WHITE}" "Exiting..."
            exit 0
            ;;
        *)
            print "${WHITE}" "Invalid choice. Please try again."
            ;;
    esac
}

arg1=$1
arg2=$2
if [ -z "$arg1" ] && [ -z "$arg2" ]; then
  while true; do
    clear
    show_menu
    read_option
    echo
    print "${WHITE}" "Press Enter to continue..."
    read -r
  done
else
  if [[ "$arg1" == "create" ]] && [[ "$arg2" =~ ^[0-9]+$ ]]; then
    create "${arg2}"
  fi
  if [[ "$arg1" == "destroy" ]] && [[ "$arg2" =~ ^[0-9]+$ ]]; then
    destroy "${arg2}"
  fi
fi
