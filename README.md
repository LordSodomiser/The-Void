# The-Void Dumps.exe - PowerShell Data Transfer

Lurking in the depths of The-Void, Dumps.exe is a PowerShell-based tool that automates shadowed data transfers from removable drives to network shares, with GUI selection, Robocopy precision, detailed logging, and defiance of screen lock policies.

## Purpose

Descends into the abyss to automate file transfers from removable storage (e.g., phones, USBs) to network shares, ensuring logging, drive mapping, and uninterrupted operation despite system sleep or lock.

## Key Features

- Network Selection: GUI for selecting mapped drives or entering UNC paths; auto-maps free drive letters.
- Removable Drive Detection: Scans and iterates through all connected removable drives.
- Robocopy Transfer: Copies files and directories, preserving timestamps and structure, with retries for network errors and exclusion of system/hidden files.
- Logging: Stores logs in Phone Dump Logs on desktop with timestamps and paths.
- Sleep Prevention: Halts system sleep/lock during transfers, restoring settings after a delay.
- Error Handling: GUI popups for retry/cancel on network issues; confirms completion.

## Use Case

Crafted for seamless data transfers from external USB drives to network shared drives, ensuring uninterrupted operation despite screen lock policies, ideal for IT and forensic workflows.

## SHA512 Checksums

Verify the integrity of Dumps.exe and source code with these SHA512 checksums:

```
6a6c03a24eceb86d8e0a76ef7eb6ccac7a5991a5786c37433eddc236106ad8dd82f133a3c62542372e5529824b6006c296a3cee201aa543e7392a8cf949ddc88  Dumps.exe
452f10916a8d6cbef73ea0e2498a72c9e092a642e27f8239c3fa60518f30e6df68225d72f2ac871ce50e5d47028fe06218cf8e7bc95f8afb78aae4e2b424421c  Dumps.ps1
```

## Verifying Integrity

To ensure files haven’t been tampered with, run:

```bash
Get-FileHash -Algorithm SHA512 Dumps.exe
Get-FileHash -Algorithm SHA512 Dumps.ps1
```

Compare output with the provided checksums.

Note: If running the source script, ensure PowerShell execution policy allows scripts (Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned).

## Source Code

The Dumps.ps1 source is included for transparency and customization. Modify as needed for specific workflows.

## Contributing

We welcome contributions! Check out our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on reporting bugs, suggesting features, or submitting pull requests. Testers are especially needed to help squash minor bugs—join the effort!

## Contact
Created and Maintained By
LordSodomiser (Into the Abyss) <lordsodomiser@proton.me>

## Support the Project

If The-Void saves you time, consider supporting its development:

[Donate via Ko-fi](https://ko-fi.com/lordsodomiser)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
