---
name: draft-pr
description: Create a draft GitHub pull request from the current branch with an uppercase ticket prefix when available, concise change bullets, rationale for non-obvious decisions, and explicit human approval through a questionnaire or plain response. Use when the user asks to draft, create, prepare, or open a PR. Do NOT use to update an existing PR or mark one ready for review.
compatibility: Requires git and GitHub CLI authentication. Uses the questionnaire tool when available and plain conversation as a fallback. A ticket integration such as Linear is optional.
---

# Draft PR

Create a well-grounded draft pull request from the current branch. Analyze the complete committed branch diff, propose a title and description, and obtain explicit human approval before changing any remote state.

## Non-negotiable rules

- Always create the pull request as a draft.
- Never push or run `gh pr create` before the user approves the exact title and body through either the questionnaire tool or a clear plain response to the displayed proposal.
- Prefer the questionnaire tool at every decision gate when it is exposed in the current session.
- If the questionnaire tool is not exposed, or an actual call returns an unavailable-tool or unsupported-UI error, present the same question and options plainly in chat and accept the user's explicit response. Never stop solely because the questionnaire is unavailable.
- If the user has already answered a pending question clearly in plain conversation, accept that answer rather than forcing a duplicate questionnaire.
- In every later instruction that says to use or repeat the questionnaire, apply this plain-response fallback policy.
- Never substitute an editor prompt for human approval.
- Include a selected or detected ticket in the title as an uppercase bracketed prefix, such as `[CPP-124]`. Proceeding without a ticket is valid when none is found or the user chooses that option; never block the PR solely because it has no ticket.
- Base every implementation claim on the committed branch diff. Do not describe unfinished ticket scope.
- Analyze the full branch range, not merely the latest commit.
- Only stage and commit pending work after the user explicitly chooses the commit-and-continue option through the questionnaire or a plain response. Once approved, rewrites and generated files produced by commit hooks during that commit are covered by the same approval: re-stage them and retry the exact approved commit message automatically as described below. Never amend, rebase, force-push, bypass commit hooks, or mark a pull request ready for review.
- Honor repository-specific contributor instructions and mandatory pull request templates.

## Workflow

### 1. Verify the repository and branch

Run independent inspection commands in parallel where possible:

- `git status --short --branch`
- `git branch --show-current`
- `git remote -v`
- `gh auth status`
- `gh repo view --json defaultBranchRef`
- `gh pr view --json url,state,isDraft,title,body` to detect an existing pull request for the branch

Then:

1. Confirm the current directory is inside a Git repository with a GitHub remote.
2. Determine the appropriate GitHub remote and its default base branch. Prefer `gh repo view`; fall back to that remote's symbolic `HEAD` only if necessary.
3. If `HEAD` is detached, propose a feature-branch name that respects repository naming rules and ask whether to create it at the current commit or abort. On approval, run `git switch -c <approved-branch>` and continue; do not stop merely because `HEAD` was detached.
4. Stop and return the URL if the current branch already has an open pull request; never create a duplicate or silently update it.
5. If the current branch is the default branch, propose a feature-branch name that respects repository naming rules and ask whether to create it or abort. On approval, run `git switch -c <approved-branch>` and continue with the current commits and working tree.
6. Fetch the selected remote's base branch so the comparison normally uses current remote state. Do not merge or rebase. Resolve one `<base-ref>` for every later log and diff command: prefer `<remote>/<base>`, but if the fetch fails, use an existing remote-tracking ref or a valid local base ref and state that the comparison may be stale. If neither ref exists, ask the user to provide a valid base ref or abort rather than stopping automatically.

### 2. Gather the complete PR context

Capture the current `HEAD` SHA, then inspect:

- `git log <base-ref>..HEAD --oneline`
- `git diff --stat <base-ref>...HEAD`
- `git diff <base-ref>...HEAD`
- `git diff` and `git diff --cached` only to identify work that will not be included
- `git status --short` for modified, staged, and untracked files
- the branch's upstream and ahead/behind state
- any repository pull request template or contributor instructions

If the working tree contains staged, unstaged, or untracked work, inspect the pending diff and use the questionnaire before drafting. Show the affected files and a proposed commit message, then offer exactly these choices:

- **commit all changes and continue** — stage all staged, unstaged, and untracked changes with `git add -A`, create a commit using the displayed message, and continue the PR workflow
- **abort so I can handle the changes manually** — stop without staging, committing, pushing, or creating a pull request

Write a concise commit message that summarizes the aggregate pending work and follows repository-specific commit conventions. The questionnaire must make clear that the commit option includes every non-ignored pending file.

If the user chooses to commit:

1. Run `git add -A`, record `HEAD`, and commit with the approved message.
2. Do not bypass hooks or use `--no-verify`.
3. If the commit command exits unsuccessfully, recheck `HEAD`, the command output, `git status --short`, `git diff`, and `git diff --cached`:
   - If `HEAD` advanced, treat the commit as successful and continue to the working-tree check; never retry and create a duplicate commit.
   - If `HEAD` did not advance and commit hooks rewrote or generated files, run `git add -A` and retry the exact approved commit message automatically. Do not request approval again for hook-produced changes.
   - Allow at most two automatic hook-rewrite retries after the initial attempt. After each unsuccessful attempt, retry only when that attempt produced new hook changes. If an attempt produces no new hook changes or both retries are exhausted, stop and report the remaining error without pushing or creating a pull request.
4. Hook-rewrite retries that do not create a commit do not count toward the limit on successful commit attempts.
5. After a successful commit, recheck the working tree. If hooks or other processes leave further changes, show the new changes and offer the same commit-all-or-abort choice one more time; do not automatically commit them under the earlier approval.
6. Allow at most two successful commit attempts in one invocation. If changes remain after the second, stop for manual resolution instead of repeating indefinitely.
7. Refresh the captured `HEAD`, commit range, and full base diff so every successful commit is included in all ticket, title, and description analysis.

If the user chooses to abort, make no repository changes.

After the working tree is clean or the approved commit succeeds, stop if there are no committed changes relative to the base branch.

### 3. Find the ticket

Search case-insensitively for ticket identifiers matching forms such as `CPP-124`, `CAP-1234`, or `ENG-567`. Check, in order:

1. any identifier supplied with the skill invocation
2. the current branch name
3. commit subjects in `<base-ref>..HEAD`

Normalize every candidate to uppercase. If exactly one identifier is found, use it. If several are found, use the questionnaire to ask which is the primary ticket for the title and include a **continue without a ticket** option.

If none is found, use the questionnaire with an explicit **continue without a ticket** option and allow the user to type an identifier. Accept and normalize any unambiguous identifier in the expected letters-or-digits plus hyphen plus number form rather than rejecting it over casing. If a typed identifier is malformed, explain the expected form and offer one correction attempt alongside **continue without a ticket**. Do not create an unbounded validation loop: after a second malformed custom response, continue without a title prefix and state that the ticket was omitted.

When an issue-tracker integration is available, read the selected ticket's title, description, acceptance criteria, and relevant discussion. Use that context to understand intent, but use the diff to determine what was actually implemented. If the tracker is inaccessible, continue from the diff and user-provided context; never invent intent from the identifier alone.

### 4. Understand the net change

Reconcile all commits and the complete branch diff into the aggregate behavior delivered by the branch:

- distinguish user-visible or operational outcomes from implementation details
- identify meaningful compatibility constraints, rollout or migration choices, architectural tradeoffs, and deliberately rejected simpler approaches
- distinguish a genuinely non-obvious decision from a merely large diff
- omit ticket scope that the branch does not implement

If the code clearly embodies an important hard decision but its reason cannot be established from the ticket, commits, code comments, or repository context, ask for the rationale with two options: **provide rationale** or **omit `Why` and continue**. If the user omits it or the supplied rationale remains unclear, continue without a `### Why` section. Never fabricate rationale or block the PR solely because rationale is unavailable.

### 5. Draft the title

Write a concise, specific title in imperative mood that summarizes the net outcome:

- With a ticket: `[CPP-124] Add automatic billing imports`
- Without a ticket: `Add automatic billing imports`

Rules:

- uppercase the entire ticket identifier, regardless of its source casing
- place one space after the closing bracket and do not add a colon
- do not end the title with a period
- prefer the delivered outcome over a raw commit message or low-level file change
- avoid vague titles such as `Update billing` or `Fix issue`
- if multiple tickets exist, include only the primary ticket selected by the user

### 6. Draft the description

Ordinarily use 1–4 short bullets:

```markdown
- import monthly billing data from render
- associate service costs with the correct reporting period
- expose billing totals to internal automation

Generated with [pi.dev](https://pi.dev)
```

Description rules:

- begin bullets with lowercase words unless a proper noun or acronym requires capitalization
- describe high-level behavior, capability, or meaningful operational change
- do not provide a file-by-file, commit-by-commit, or symbol-by-symbol inventory
- omit routine tests, enums, types, helpers, renamed files, and ordinary refactors unless they are themselves the meaningful outcome
- do not add `Fixes`, `Closes`, a test plan, or generic `Summary` headings unless the user or repository explicitly requires them
- keep the attribution separate from the bullet list

For a longer or more complicated pull request, add `### Why` only when the implementation contains a substantiated non-obvious decision or tradeoff that reviewers need to understand:

```markdown
- preserve legacy report behavior while moving new facilities to configurable rules
- add validation for unsupported rule combinations

### Why

The rollout keeps existing facilities on their proven path because migrating them simultaneously would make calculation drift difficult to isolate.

Generated with [pi.dev](https://pi.dev)
```

Use a brief paragraph or compact bullets under `### Why`. Explain the constraint, tradeoff, or reason the simpler approach was rejected. Do not add this section merely because many files changed, and do not invent rationale.

If repository instructions require a particular template, preserve its mandatory sections while applying these brevity and rationale rules within them.

### 7. Require human approval

Present the complete proposal through the questionnaire when available, or plainly in chat when using the fallback. Include both:

- `Title:` followed by the exact proposed title
- `Description:` followed by the exact Markdown body

Offer these choices:

1. **create draft PR as shown**
2. **revise title or description**
3. **cancel**

Allow free-form input for requested edits.

- On **create draft PR as shown**, proceed only with the exact displayed title and body.
- On **revise title or description**, collect the requested changes through the questionnaire or plain conversation, produce a revised proposal, and repeat this approval step.
- On **cancel**, stop without pushing or creating a pull request.
- Treat free-form input as revision instructions, then repeat approval.
- In the plain fallback, accept a direct affirmative response such as `yes`, `create it`, or `proceed` when it clearly answers the displayed proposal.

There is no implicit approval. Approval of an earlier version does not approve a subsequently revised title or body, and an ambiguous response must be clarified before proceeding.

### 8. Revalidate and create the draft PR

After approval:

1. Verify `HEAD` still equals the SHA captured before drafting. If it changed once, recompute the diff from `<base-ref>`, redraft, capture the new SHA, and repeat human approval. If it changes again before creation, ask the user to pause concurrent changes or abort; do not enter an unbounded redraft loop.
2. Verify no open pull request has appeared for the branch in the meantime.
3. Recheck upstream state. Never force-push. If the branch has diverged or cannot be pushed safely, stop and explain the problem.
4. Push normally to the existing upstream. If no upstream exists, push with `-u` to the selected GitHub remote.
5. Write the approved body to a uniquely named temporary file outside the worktree. Do not overwrite an existing file.
6. Run:

   ```bash
   gh pr create --draft --base "<base>" --title "<approved title>" --body-file "<temporary file>"
   ```

7. Delete the temporary body file after success or failure.
8. Verify the returned pull request is a draft and return its URL.

If the push or pull request creation fails, report the command error plainly. Do not retry with destructive Git operations or create a non-draft pull request.
