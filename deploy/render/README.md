# Web-accessible ecommerce and zone-agent demo on Render

Repository: https://github.com/Abhishek-Chatterjee-git/sim-enterprise. Use the repository root as the Blueprint root. The current local changes must be committed and pushed before Render can see them.

## Services and billing

render.yaml defines an always-on paid storefront, a paid background worker, paid PostgreSQL, and a 1 GB agent disk in Singapore. Review Render's estimate before creating resources. Paid compute is distinct from a workspace subscription; do not buy a team workspace plan solely to run the worker. Current plan IDs are 0.5c-512mb for services and 0.1c-256mb for the database. See https://render.com/docs/compute-plans and https://render.com/docs/blueprint-spec.

Background workers do not accept incoming traffic (https://render.com/docs/background-workers). This demo disables the storefront's optional local-agent cache synchronization. Portal consent delivery, database discovery, and approved erasure do not require that endpoint. The worker polls the existing EC2 control plane over HTTPS. Local agent cache enforcement is not demonstrated by this topology; use a private service instead if that endpoint is required later.

## Deploy the storefront first

1. Create a Blueprint from this repository and select render.yaml. Review the paid resources.
2. Supply the organization COMPLIANCE_API_KEY_ID and COMPLIANCE_API_KEY_SECRET as Render secrets. Use the artison-sons key with consent:write, consent:read, and dsr:write. Do not paste secrets into Git or browser JavaScript.
3. Leave the worker DATABASE_URL temporarily blank if the setup permits it; otherwise supply the managed database internal URL temporarily. The worker waits for bootstrap secrets and will not enroll at this point.
4. Wait for the storefront health check to pass. Startup creates the demo schema and seeds the existing small catalog/customer fixture. This does not migrate the local database or import the large CSV dataset.
5. Open the HTTPS storefront URL and /privacy. Create a fresh account with a real inbox for verification. The data resides in Render PostgreSQL, not local PostgreSQL.

## Prepare the agent role

In the storefront Render shell, set a private DEMO_AGENT_DB_PASSWORD of at least 32 random characters and run:

```sh
node deploy/render/prepare-agent-db.mjs
```

The web Docker image includes this deployment directory. The script creates demo_zone_agent, grants schema usage and discovery SELECT permissions, and grants UPDATE on users for the masking demo. It does not grant DELETE, schema modification, or erasure on other tables. It is safe to rerun to rotate the password.

Copy the database's INTERNAL connection string into the worker's DATABASE_URL, replacing its username/password with this role and password. Percent-encode password characters in the URL. Keep the role URL out of chat and Git. Remove the temporary password variable from the storefront environment when finished. Both services must use the same Render database.

## Install and enroll the worker

Wait until the worker image is built and its logs say it is waiting for portal installation environment. Then generate FRESH install commands in D-fortress for this organization and add these worker environment values together. Save/restart promptly within the ten-minute window:

| Worker variable | Value from portal commands |
|---|---|
| INSTALLER_URL | Full download URL for install.sh |
| INSTALLER_SHA256 | Expected SHA-256 for install.sh |
| VERIFIER_URL | Full download URL for verify-release.mjs |
| VERIFIER_SHA256 | Expected SHA-256 for verify-release.mjs |
| RELEASE_MANIFEST_TOKEN | --manifest-token value |
| RELEASE_TARBALL_TOKEN | --tarball-token value |
| AGENT_ENROLLMENT_TOKEN | Enrollment token |

The startup wrapper checks bootstrap digests, invokes the portal installer to verify the release signature/checksum, and installs onto the persistent disk. It never downloads a package from public npm as a substitute for the licensed release. Redeemed bootstrap files are reused after a retry when their digest matches. If manifest/tarball links expire or have already been consumed, generate fresh commands; do not repeatedly reuse them.

The worker runs the foreground `dpdp agent start` process. Identity, credentials, signing key, and task journal live at /var/lib/d-fortress/data; the installed release lives at /var/lib/d-fortress/installed. Restarts reuse these and do not require new installation tokens. After enrollment is ACTIVE, remove bootstrap URLs/tokens and the enrollment token from Render environment. Keep the disk and run one worker instance. Never copy the local agent's identity to create a second live instance.

The Blueprint explicitly uses AGENT_MTLS=off, matching the earlier working demo's verified HTTPS plus enrolled credential transport. Certificate enrollment was previously failing in the control plane. This remains a limitation; change to required only after certificate issuance/renewal works. The wrapper does not change platform authentication or ML-DSA-65 configuration.

## Demonstration checklist

- Confirm the new Render agent is ACTIVE in D-fortress and discovers the Render database.
- Create a fresh customer using a real inbox, then grant and withdraw a purpose; verify the portal records.
- Start deletion in /privacy and verify the emailed code. Challenge bindings are stored in PostgreSQL so a storefront redeploy does not discard them.
- Review and approve an erasure plan targeting the Render agent and Render database, not the old local target. Use users.email and soft-delete/mask, with a portal cap at or below five.
- Verify the masked columns and receipt. The email remains unless the plan includes it. Related orders/payments are not automatically erased by a users-only plan.
- Restart the worker and check its identity and completed-task journal persist.

Do not claim full consent enforcement, full multi-table deletion, or signed ML-DSA-65 evidence until those specific paths pass. Use disposable demo accounts; existing seeded identities are fixtures.

## Operational limits

Changing environment values in an existing Blueprint may require adding them manually; sync:false prompts only during initial creation. The bootstrap wrapper pins the installed release on its disk. Upgrading that release requires a deliberate verified upgrade, not an automatic image rebuild. Do not delete identity/journal state during upgrades.

Source references: https://render.com/docs/disks, https://render.com/docs/background-workers, https://render.com/docs/blueprint-spec.
