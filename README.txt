## Tasks Summary

1. **Resource Deployment**:
   - Deployed a Linux VM and two storage accounts using ARM templates (`linuxVM.json`, `storageAccounts.json`).
   - Automated deployment via `azure-pipelines.yml`.

2. **Configure Monitoring**:
   - Enabled diagnostics for storage accounts (Storage Read, Write, Delete) and VM (CPU, disk, network).
   - Linked resources to Log Analytics Workspace.

3. **Dashboard Creation**:
   - Created Azure Monitor dashboard to display key metrics (transactions, CPU %, availability).
   - Saved dashboard as `Dashboard/Metrics.json`.

4. **Repository Setup**:
   - Includes ARM templates, pipeline configuration, scripts, and dashboard screenshots.

---

## Steps to Reproduce

1. Deploy resources using ARM templates or pipeline.
2. Configure diagnostics and link to Log Analytics Workspace.
3. Import `Metrics.json` to Azure Monitor for the dashboard.

---

For more details, review the repository files.
