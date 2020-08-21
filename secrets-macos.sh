# be sure to load this file with 'source ./filename'

# project name that uniquely identifies this within your keychain
project=GCP

## declare secrets
declare -a arr=("GOOGLE_CREDENTIALS" "DUCK_DNS_TOKEN" "DUCK_DNS_DOMAIN" "TF_VAR_gcloud_project")  

## get or prompt each secret
for i in "${arr[@]}"; do
  # get the password from the keychain
  secret=$(security find-generic-password -a "${USER}" -s "secret_${project}_${i}" -w 2>&1)

  # if the security command does not run sucessfully, prompt for secret
  if [ $? -gt 0 ]; then
    echo -n "What is the secret for ${i}:"
    read -s SECRET
    SECRET_B64=$(printf "%s" "$SECRET" | base64)
    security add-generic-password -U -a "${USER}" -s "secret_${project}_${i}" -w "$SECRET_B64"
    secret=$(security find-generic-password -a "${USER}" -s "secret_${project}_${i}" -w)
  fi
  export "${i}=$(printf "%s" $secret | base64 -d)"
done
