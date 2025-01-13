#!/bin/bash

STORAGE_ACCOUNT_A="gilstorageisrael1"
STORAGE_ACCOUNT_B="gilstorageisrael2"
CONTAINER_A="container1"
CONTAINER_B="container2"
SAS_TOKEN="$1"

# checking if SAS Token Input has entered 
if [[ -z "$SAS_TOKEN" ]]; then
  echo "Error: SAS token not provided. Pass it as the first argument to the script."
  exit 1
fi

# Creating Containers
echo "Creating containers..."
az storage container create --account-name $STORAGE_ACCOUNT_A --name $CONTAINER_A || { echo "Failed to create container $CONTAINER_A in $STORAGE_ACCOUNT_A"; exit 1; }
az storage container create --account-name $STORAGE_ACCOUNT_B --name $CONTAINER_B || { echo "Failed to create container $CONTAINER_B in $STORAGE_ACCOUNT_B"; exit 1; }

# Generating Files
echo "Generating test files..."
mkdir -p blobs
for i in {1..3}; do
  echo "This is blob $i" > blobs/blob$i.txt
done

# Uploading the Blobs to Storage Account A and checks if the operations succeeded
echo "Uploading blobs to $STORAGE_ACCOUNT_A/$CONTAINER_A..."
for i in {1..3}; do
  az storage blob upload \
    --account-name $STORAGE_ACCOUNT_A \
    --container-name $CONTAINER_A \
    --name blob$i.txt \
    --file blobs/blob$i.txt \
    --overwrite || { echo "Failed to upload blob$i.txt to $CONTAINER_A in $STORAGE_ACCOUNT_A"; exit 1; }
done

# Copying the Blobs to Storage Account B and checks if the operations succeeded
echo "Copying blobs to $STORAGE_ACCOUNT_B/$CONTAINER_B..."
copy_successful=true
for i in {1..3}; do
  az storage blob copy start \
    --destination-container $CONTAINER_B \
    --destination-blob blob$i.txt \
    --source-uri "https://$STORAGE_ACCOUNT_A.blob.core.windows.net/$CONTAINER_A/blob$i.txt?$SAS_TOKEN" \
    --account-name $STORAGE_ACCOUNT_B || { echo "Failed to copy blob$i.txt to $CONTAINER_B in $STORAGE_ACCOUNT_B"; copy_successful=false; }
done

# Validate copy operation
if [[ "$copy_successful" != true ]]; then
  echo "Error: One or more blobs failed to copy. Check the logs above for details."
  exit 1
fi

# removing the Local Files
echo "Cleaning up local files..."
rm -rf blobs

echo "Script completed successfully!"