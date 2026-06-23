---
name: release-notes
description: Generate CHANGELOG entries from git history
disable-model-invocation: true
---

# Release Notes Generator

Generate CHANGELOG entries for a new release based on git commit history.

## Usage

```
/release-notes 0.0.2
```

## Process

1. **Get the version**: Use the provided version argument (e.g., `0.0.2`).
   - **CHANGELOG header and `pubspec.yaml`**: plain number, **no `v` prefix**
     (pub.dev requires the CHANGELOG header to match `pubspec.yaml`).
   - **git tag**: **with `v` prefix** (e.g. `v0.0.2`) — matches the existing
     tag convention (`v0.0.1`).

2. **Find the previous release**:
   ```bash
   git describe --tags --abbrev=0 HEAD 2>/dev/null || git log --reverse --format="%H" | head -1
   ```

3. **Get commits since last release**:
   ```bash
   git log <prev-tag>..HEAD --oneline --no-merges
   ```

4. **Categorize commits** by conventional commit prefix:
   - `feat:` → ✨ Features
   - `fix:` → 🐛 Bug Fixes
   - `refactor:` → ♻️ Refactoring
   - `docs:` → 📚 Documentation
   - `test:` → ✅ Tests
   - `chore:` → 🔧 Chores
   - `style:` → 💅 Style
   - `perf:` → ⚡ Performance

5. **Generate the CHANGELOG entry** matching the existing file style
   (plain `## <version>` header, bullet lists). Keep it simple — group by
   category only if there are enough entries to warrant it:

```markdown
## 2.1.0

### ✨ Features
- Add starred / favourite feature for request records.

### 🐛 Bug Fixes
- Handle nested params in COS token response.

### ♻️ Refactoring
- Replace hardcoded Feishu hook with configurable onShareAction.
```

   For small releases, a flat bullet list (like the existing `1.0.1` /
   `1.0.2` entries) is fine.

6. **Flag breaking changes**: If any commit changes the public API, add a
   `**Breaking changes**` note and a migration guide (see the `2.0.0` entry
   for the established format).

7. **Update pubspec.yaml version**:
   - Read the existing `pubspec.yaml`.
   - Update the `version:` field to match the new version.
   - This is the canonical version source for Dart packages.

8. **Update CHANGELOG.md**:
   - Read the existing `CHANGELOG.md`.
   - Prepend the new entry at the top of the file.
   - Write the updated file.

## Output

- Print the generated release notes to the user.
- Ask if they want to update `CHANGELOG.md` and `pubspec.yaml`.
- If yes, update both files and commit:
  ```bash
  git add CHANGELOG.md pubspec.yaml
  git commit -m "docs: update CHANGELOG for 0.0.2 and bump version"
  ```
- Ask if they want to create and push the git tag (tag uses the `v` prefix):
  ```bash
  git tag -a v0.0.2 -m "v0.0.2: <brief description>"
  git push origin HEAD
  git push origin v0.0.2
  ```

## Example

User: `/release-notes 0.0.2`

Claude:
1. Gets commits since the previous tag.
2. Categorizes them.
3. Generates formatted release notes.
4. Shows the preview.
5. Asks to update CHANGELOG.md, pubspec.yaml, and create a tag.
6. Updates CHANGELOG.md, bumps pubspec.yaml version.
7. Commits both files.
8. Creates the git tag and pushes.

## Notes

- **Version numbers**: CHANGELOG header and `pubspec.yaml` use a plain number
  (`## 0.0.2`, no `v`, no commit SHA); the **git tag** uses the `v` prefix
  (`v0.0.2`).
- Only include meaningful commits (skip noise like "apply dart format" or
  "temp" unless significant).
- Group related commits together.
- Use the commit message as-is (don't rewrite); if a commit has a body, use
  the body as the description.
- **pubspec.yaml** is the canonical version source for Dart packages — always
  update it.
- **git tags** should be annotated (`-a`) with a brief description message.
- Push the branch first, then the tag separately.
- Highlight **breaking changes** with a migration guide when the public API
  changes (see `2.0.0`).
