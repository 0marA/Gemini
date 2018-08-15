# sfml-vscode-boilerplate
An SFML 2.5.0 C++17 configuration for Visual Studio Code

## Prerequisites

* [SFML 2.5.0 - MinGW (GCC) 7.3.0 DW2 32-bit](https://www.sfml-dev.org/files/SFML-2.5.0-windows-gcc-7.3.0-mingw-32-bit.zip)
* [MinGW (GCC) 7.3.0 DW2 32-bit](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/7.3.0/threads-posix/dwarf/i686-7.3.0-release-posix-dwarf-rt_v5-rev0.7z/download)
* [Visual Studio Code (Windows version)](https://code.visualstudio.com/download)
  * [Official C/C++ Extension (0.17.4+)](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
  * [Include Autocomplete Extension (Optional)](https://marketplace.visualstudio.com/items?itemName=ajshort.include-autocomplete)
* [Git Bash (for Windows) ](https://git-scm.com/downloads)

## Installation

1. Download & Extract SFML to **C:/SFML-2.5.0/** where the bin/lib/include folders are contained within
2. Download & Extract MinGW to **C:/mingw32/** where the bin/lib/include folders are contained within
4. Download & Install Visual Studio Code if you don't already have it.
5. Install the official **C/C++** Extension, reload the window & wait for the dependencies to install.
6. _(Optional)_ Install the **Include Autocomplete** extension. The C++ extension has decent include functionality already, but this one is a little better about headers contained in sub-folders. Note: It leverages the **"includePath"** array in **c\_cpp\_properties.json**
7. If on Windows, install **Git Bash**, and ensure the **"terminal.integrated.shell.windows"** property in the project's **settings.json** is set to **bash.exe**'s correct location (default: C:/Program Files/Git/bin/bash.exe). We'll be using this for the terminal in our workspace so that the Makefile can run in both Windows, Mac & Linux (although Mac configuration is untested thus far)
8. Also in **tasks.json** Ensure **Path** in the **options > env** object is set to the correct location of the compiler's executable (example: C:\\mingw32\\bin) and the SFML directory is correct as well. Keep in mind Paths should be separated by a semi-colon with no spaces between.

**Note:** In previous versions of VS Code, the "Path" environment variable had to be set within Windows, but as of version 0.17.4 of the C++ plugin, you can safely take out **C:\\mingw32\\bin** from there, and set it from the **tasks.json** under **options > env**. This way, multiple projects can use different compilers, as well as a sandboxed environment. This configuration overrides Path anyway, so you shouldn't have to worry about it right away. It also allows you to keep your environment contained/defined in VS Code.

## Configuration

At this point, everything you need is installed

1. Open the **sfml-vscode-boilerplate** folder in VS Code. You should see an lime-green status bar at the bottom (color-picked from the SFML logo).
2. At this point you should be able to run a build task (**Ctrl+Shift+B** > **Build & Run**), but it'll be nicer to add keybindings for these tasks so you can build with 1 keypress.
3. Open the .vscode folder and click on the **\_keybindings.json** file. This is not an officially recognized file, but just contains the keybindings you can copy into the actual keybindings.json file.
4. Go into **File** > **Preferences** > **Keyboard Shortcuts** & click on the keybindings.json link at the top.
5. Copy the keybindings into this file. Feel free to change them if you don't like them later.
6. Hit the **F9** key to run the **Build & Run: Release** task. It should run the Makefile, find the compiler, build the Main.cpp into Main.o, and launch the green circle hello world that you should recognize from the official SFML guide. **Shift+F9** will launch the basic Debug build, and F8 will launch the actual Debugger along with the Debug build.

## Makefile Environment

Originally, this boilerplate used tasks.json to contain all the environment variables, but I've since moved them out into separate .mk (Make) files to organize them by build type & platform, so you can customize which SFML libraries to include if you want, or pretty much anything without having to edit the tasks.json. Each .mk file is outlined below:

    ./env.mk: All platforms/builds

    ./env/.debug.mk: All platforms, Debug build  
    ./env/.release.mk: All platforms, Release build  
    
    ./env/windows.all.mk: Windows, All builds  
    ./env/windows.debug.mk: Windows, Debug build  
    ./env/windows.release.mk: Windows, Release build  
    
    ./env/linux.all.mk: Linux, All builds  
    ./env/linux.debug.mk: Linux, Debug build  
    ./env/linux.release.mk: Linux, Release build

    (OSX will be added when I can test it)


## Adding Source Files

In the base boilerplate, add sources files in **SOURCE_FILES** within **./env.mk**, separated by **\\** characters. Same for **PROJECT_DIRS**. Feel free to move these from env.mk to one of the other .mk files, but be aware that out of the box, they'll override the main env.mk, so you'll need to manage them yourself.


## Environment Variables

The environment variables that can be added to each one are outlined below. If you need a line-break anywhere simply add a **"\\"** character.


**SOURCE_FILES**: Add **.cpp** or **.rc** files relative to the **src/** directory
```makefile
SOURCE_FILES= \
  Main.cpp \
  WindowManager.cpp \
  Game/Character.cpp \
  Graphics/ParticleSystem.cpp \
  Utility/Geometry.cpp \
  SceneManager/SceneManager.cpp \
  SceneManager/Scene.cpp \
  SceneManager/Scenes/SceneTitle.cpp
```

**PROJECT_DIRS**:  
Add any subfolders you're using with the **src/** directory
```makefile
PROJECT_DIRS= \
  Game \
  Graphics \
  Utility \
  SceneManager \
  SceneManager/Scenes
```

**LIB_DIRS**:  
Add any additional lib directories (full path)
```makefile
LIB_DIRS= \
  C:/sfeMovie/lib \
  C:/myLibraries/lib
```

**INCLUDE_DIRS**:  
Add any additional include directories (full path)
```makefile
INCLUDE_DIRS= \
  C:/sfeMovie/include \
  C:/myLibraries/include
```

**LINK_LIBRARIES**:  
Add any additional link libraries
```makefile
LINK_LIBRARIES= \
  XInput \
  user32 \
  something
```

**FLAGS_RELEASE**: Additional compiler flags for the particular build (including prefix)
```makefile
BUILD_FLAGS= \
  -mwindows
```

**BUILD_MACROS**: Macros to include in the build
```makefile
BUILD_MACROS= \
  _DEBUG
```

## Build: Production

I thought it was important to include a build task that creates a final "build" folder and copies the files in the bin/Release folder, any dependency .dlls, and any other directories into it. It's accessed via (**Ctrl+Shift+B** > **Build: Production**) and uses a couple special environment variables:

**PRODUCTION_DEPENDENCIES**: Files & folders to copy into the "build" folder upon using the "Build: Production" task.
```makefile
PRODUCTION_DEPENDENCIES= \
  C:/mingw32/bin/libgcc_s_dw2-1.dll \
  C:/mingw32/bin/libstdc++-6.dll \
  C:/mingw32/bin/libwinpthread-1.dll \
  C:/SFML-2.5.0/bin/openal32.dll \
  C:/SFML-2.5.0/bin/sfml-audio-2.dll \
  C:/SFML-2.5.0/bin/sfml-graphics-2.dll \
  C:/SFML-2.5.0/bin/sfml-network-2.dll \
  C:/SFML-2.5.0/bin/sfml-system-2.dll \
  C:/SFML-2.5.0/bin/sfml-window-2.dll \
  content
```

**PRODUCTION_EXCLUDE**: Files & extensions to exclude from the production build.
```makefile
PRODUCTION_EXCLUDE= \
  *.psd \
  *.rar \
  *.7z \
  Thumbs.db
```


## Include directories & .vscode folder

If you need to add additional external libraries, these are a couple different places to keep in mind.

* **.vscode/c\_cpp\_properties.json** - You'll see **compilerPath** & **includePath**. The compilerPath includes all the compiler's directories so, the includePath only needs the root project directory and any additional libraries you want to include. SFML is included as well in this boilerplate. See details below.

  * _"compilerPath"_ - Path to the compiler's binary to use (in our case, it's MinGW GCC.
  * _"includePath"_ - Used by the C/C++ extension for additional include directories. We include the relative project directoy by default. You can also add directories recursively with **/****

* **.vscode/settings.json** - Contain all of your workspace settings & overrides VS Code's main settings.json. Here are some settings of interest:

  * _"files.exclude"_ - Add any filetypes you want to exclude from the folder panel.
  * _"files.encoding"_ - This uses the same encoding as CodeBlocks (**windows1252**), but feel free to change it to suit your needs.
  * _"editor.fontFamily"_ - I set this to Courier by default to that CodeBlocks feel. Change/remove this line if you want to stick to VS Code's default (Consolas), or your own preference. Same with _"editor.fontSize"_ & _"editor.lineHeight"_.
  * _"terminal.integrated.env.****"_ - Environment variables for use when the terminal runs. Note: These override the OS defaults.

* **.vscode/launch.json** - Used to store the configuration to launch the debugger.
* **.vscode/tasks.json** - Used to store the task definitions (Build & Run commands, etc.).
* **.vscode/_keybindings.json** - As mentioned before, this is used purely to store handy keybindings that one can add themselves, and not recognized by VS Code.

## Multiple Projects

Recently, I wanted to avoid duplicate Makefiles in my various projects, so I found a nice little solution to do this.

1. Start by creating a folder structure where something like **SFML** is your root folder for SFML projects, and the **sfml-vscode-boilerplate** is contained within. We'll rename it to **sfml-project1**.
2. Copy the Makefile from **sfml-project1** to the root **SFML** directory
3. Edit the Makefile in **sfml-project1**, replace the entire contents to simply have:
  ```
  include ../Makefile
  ```
4. Make a copy of **sfml-project1** and call it **sfml-project2**
5. Open either project in vscode, and they should each should compile! Voila! You can now use a shared Makefile between projects this way

## Notes

* This configuration assumes all source files are contained within the **src** folder, but uses the **root** as the working directory for assets & things referenced in your project.
* By default, this configuration uses C++17. You can change the compiler flags in **env/\<platform\>.all.mk** under **CFLAGS**.
* If for some reason after an update, the build scripts don't work, reinstall the C/C++ extension and it should work again (this was an issue in an older version of the extension anyway).
* Feel free to offer suggestions/report issues if there's anything I missed, or could do better.
* This will be an ongoing project that I'll try to update as new SFML versions come out. Updating SFML releases should be relatively painless as I'll keep the Prereqs up to date as well.


That should be all you need to get started. Happy game making!