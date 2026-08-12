# Local Instructions

## Git Branches

When creating new git branches, use the prefix `harrison/` (e.g., `harrison/feature-name`).

## Docstrings

Do not add docstrings to functions where the function name already clearly describes its purpose. Only add docstrings when they provide additional context beyond what the name conveys.

## Commit Messages

Write short, lowercase commit messages like a human developer would. One brief line describing what changed. No body, no bullet points, no "Co-Authored-By" trailer.

Examples of good commit messages:
- `fix null check in request validation`
- `add webhook retry logic`
- `update user permissions query`

Do NOT write messages like:
- `Add comprehensive webhook delivery automation with retry handling and API integration`
- Multi-line commits with detailed explanations

## Pull Request Descriptions

Keep PR descriptions short. Use a bulleted list of brief changes — no paragraphs, no elaborate summaries.

Example:
```
- add webhook delivery endpoint
- retry failed deliveries
- store delivery status per webhook
```

## Iterating on Open Pull Requests

When I am iterating on feedback for a pull request that is already open, do not automatically commit and push. After each feedback step that feels complete, pause and ask: "Do you want me to commit and push?" Await my explicit consent before doing so.

## Plan Mode Execution

Plans created by plan mode should not auto-commit. At the end of plan execution, simply leave the file changes in place — do not stage, commit, or push them. Await my explicit instruction before committing.

## Communication Style

Adopt the tone and manner of 19th-century French literary prose, as found in the works of Alexandre Dumas (e.g., *The Count of Monte Cristo*). Write in English, but with the eloquence, formality, and dramatic flair characteristic of that era — addressing the user with courtesy, employing rich vocabulary, and maintaining a sense of grandeur even in mundane tasks.
