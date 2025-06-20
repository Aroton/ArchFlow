# ArchFlow Verify Command

Final quality gate - verify implementation matches plan and passes all automated and manual checks.

## Usage
- `/archflow:verify [plan-path]` - Verify implementation from specific completed plan path
- `/archflow:verify` - Verify implementation from latest completed plan (finds most recent plan automatically)

## Instructions

1. **Initialize verification tracking**
   - Use TodoWrite to create verification task list
   - Read completed plan file to understand what was implemented

2. **Run automated verification suite**
   - Execute full test suite (unit tests, integration tests, end-to-end tests)
   - Run comprehensive linting and code style checks
   - Execute type checking if applicable (TypeScript, mypy, etc.)
   - Verify build succeeds in clean environment
   - Document all test results and any failures found

3. **Perform comprehensive code review**
   - Review all commits made since plan creation (use git log and git diff)
   - Compare actual implementation against each planned step
   - Validate code follows established project patterns and standards
   - Check that business logic matches architectural requirements
   - Verify error handling and edge cases are properly implemented
   - Ensure security best practices are followed
   - Confirm performance considerations are addressed

4. **Validate implementation completeness**
   - Verify all plan steps were implemented as specified
   - Check that acceptance criteria for each step are met
   - Ensure no planned functionality was missed or incomplete
   - Validate integration points work correctly
   - Confirm user experience matches design requirements

5. **Generate comprehensive verification report**
   - List all automated tests run and their results
   - Document code review findings and any issues discovered
   - Summarize compliance with architectural decisions
   - Note any deviations from the original plan and their justification
   - Provide recommendations for any issues found

6. **Update plan with verification status**
   - If all checks pass: add `verified: true` to plan metadata
   - If issues found: add `verified: false` with detailed issue list
   - Include verification timestamp and summary

7. **Commit verification results**
   - Commit plan updates with verification status
   - Include verification report if significant issues were found

8. **Present detailed results**
   - Provide clear success/failure status to user
   - Present comprehensive report of verification findings
   - Mark all todos as completed

## Error Handling

- If plan path not provided and no plans found: Request user to specify plan path or run execution phase first
- If plan shows incomplete steps: Report which steps need completion before verification
- If automated tests fail: Document failures and suggest fixes, mark verification as failed
- If code review reveals issues: Document issues clearly and mark verification as failed
- If build fails: Report build errors and mark verification as failed
- If unable to run certain checks: Document limitations and proceed with available verification

## Example Output

```
✅ Verification phase completed successfully

Verified plan: archflow/plans/20241220143022-user-authentication.md

Verification Results Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUTOMATED CHECKS                                                        ✅ PASS
├─ Unit Tests: 47/47 passing (0 failures, 0 skipped)
├─ Integration Tests: 12/12 passing  
├─ Linting: No issues found (ESLint, Prettier)
├─ Type Checking: No type errors (TypeScript)
└─ Build: Successful in clean environment

CODE REVIEW                                                             ✅ PASS
├─ All 8 planned steps implemented correctly
├─ Code follows project patterns and standards
├─ Security best practices implemented (password hashing, JWT validation)
├─ Error handling comprehensive and consistent
├─ Performance considerations addressed (DB indexing, caching)
└─ No architectural deviations detected

IMPLEMENTATION COMPLETENESS                                              ✅ PASS
├─ User registration with email validation
├─ Login/logout with JWT tokens
├─ Password reset functionality
├─ Session management and refresh tokens
├─ API endpoint security middleware
├─ Frontend authentication forms
├─ Integration with existing user system
└─ Comprehensive test coverage (94.2%)

Plan status updated: verified: true
Verification completed at: 2024-12-20T14:30:22Z

🎉 Feature implementation successfully verified and ready for deployment!
```