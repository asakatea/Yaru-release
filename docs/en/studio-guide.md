# Studio Guide

## Audience and scope
Studio is Yaru's creator and governance workspace for structured content production.

## Core capabilities
- Create/edit resources and structured content
- Manage review and publishing status
- Operate role-gated administration flows
- Maintain docs and content quality loops

## Role model
Studio actions are permission-based. Typical elevated roles include contributor/content admin/admin/owner depending on module scope.

## Typical workflow
1. Draft content in editor/studio pages.
2. Validate metadata and localization fields.
3. Submit for review or publish under role policy.
4. Monitor feedback and iterate.

## Practical tips
- Keep content IDs and slugs stable.
- Use staged review before final publish.
- Track schema-impacting changes in migration notes.

## Troubleshooting
- 403 on write operations: role is insufficient.
- Missing draft state: confirm save/publish path.
- Inconsistent content view: clear cache and refresh docs metadata.

## Related docs
- `developer-guide`
- `extensions-guide`
- `settings-guide`
