# ArchFlow Installation and Setup

This document provides instructions on how to set up your global RooCode profiles and initialize a new workspace using the Archflow structure.

## Prerequisites

-   Bash shell (common on Linux and macOS, available on Windows via WSL or Git Bash)
-   VS Code with the RooCode extension installed.
-   This ArchFlow repository cloned or downloaded to your local machine.

## Setup Steps

### 1. Make Scripts Executable

Before running the scripts, you need to make them executable. Navigate to the root directory of this ArchFlow repository in your terminal and run:

```bash
chmod +x update_global_modes.sh init_adr_workspace.sh
```

### 2. Update Global RooCode Profiles (Optional)

This step synchronizes the custom modes defined in this repository (`custom_modes.json`) with your global VS Code RooCode settings. This makes the Archflow-specific modes (like the Archflow MicroManager) available in all your projects.

**From the root directory of the ArchFlow repository**, run the following script:

```bash
./update_global_modes.sh
```

The script will copy `custom_modes.json` to the appropriate VS Code settings directory. You might need to restart VS Code for the changes to be fully recognized.

### 3. Initialize a New Archflow Workspace

This script sets up the standard folder structure and copies necessary template files for the Archflow workflow into a directory of your choice.

**Option A: Running from any directory (Recommended for PATH setup)**

If you add the ArchFlow repository directory to your system's PATH environment variable, you can run the script directly from the directory you want to initialize.

1.  **Add ArchFlow to PATH (Example for bash/zsh):**
    Add the following line to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`), replacing `/path/to/your/ArchFlow` with the actual path to this repository:
    ```bash
    export PATH="/path/to/your/ArchFlow:$PATH"
    ```
    Reload your shell configuration (e.g., `source ~/.bashrc`) or open a new terminal.

2.  **Navigate to your desired workspace directory:**
    ```bash
    mkdir my-new-project
    cd my-new-project
    ```

3.  **Run the initialization script:**
    ```bash
    init_adr_workspace.sh
    ```

**Option B: Running with Full Path**

If you prefer not to modify your PATH, you can run the script using its full path.

1.  **Navigate to your desired workspace directory:**
    ```bash
    mkdir my-new-project
    cd my-new-project
    ```

2.  **Run the initialization script using its full path:**
    Replace `/path/to/your/ArchFlow` with the actual path to this repository.
    ```bash
    /path/to/your/ArchFlow/init_adr_workspace.sh
    ```

**After running the script:**

The script will create the following structure in your current directory (`my-new-project` in the examples):

```
.
├── architecture/
│   ├── overall-architecture.md
│   ├── features/
│   │   └── template.md
│   ├── adr/
│   │   └── 0000-template.md
│   └── diagrams/
├── plans/
```

You can now initialize a git repository (`git init`) and start your project using the Archflow development process.