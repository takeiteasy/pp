# pp

_pp_ **[ˈpiːpiː]** or "_Pixel Playground_" is a small enviroment for quick experimentation with software rendering. Very simple API, build on top of my own [bitmap](https://github.com/takeiteasy/headers/blob/master/bitmap.h) library. See [here](https://takeiteasy.github.io/pp/) for documentation. Includes a live coding option built in, see [building](https://github.com/takeiteasy/pp#building) for more info.

<p align="center">
     <img src="https://github.com/takeiteasy/pp/blob/master/live.gif?raw=true">
</p>

## Examples

### Live

```c
#include "pp.h"
#include <stdlib.h>

struct ppState {
    int clearColor;
};

// Called once at the beginning of runtime
static ppState* init(void) {
    ppState *state = malloc(sizeof(ppState));
    if (!state)
        return NULL;
    state->clearColor = Black;
    return state;
}

// Called once at the end of runtime
static void deinit(ppState *state) {
    if (!state)
        return;
    free(state);
}

// Called whenever the app is modified and reloaded
static void reload(ppState *state) {
    state->clearColor = RGB(ppRandomInt(256), ppRandomInt(256), ppRandomInt(256));
}

// Called just before the app is reloaded
static void unload(ppState *state) {
}

static bool event(ppState *state, ppEvent *e) {
    switch (e->type) {
        case KeyboardEvent:
            printf("EVENT: Keyboard key %d is now %s\n", e->Keyboard.key, e->Keyboard.isdown ? "pressed" : "released");
            break;
    }
    return true;
}

// Called every frame
static bool tick(ppState *state, Bitmap *pbo, double delta) {
    FillBitmap(pbo, state->clearColor);
    DrawString(pbo, "Rebuild to change the background color!", 1, 1, White);
    DrawRect(pbo, 50, 50, 50, 50, Red, true);
    return true;
}

// App descriptor to direct callbacks
// Must be called "pp" as that is the symbol that is looked up
EXPORT const ppApp pp = {
    .init = init,
    .deinit = deinit,
    .reload = reload,
    .unload = unload,
    .event = event,
    .tick = tick
};

```

### Library

```c
#include "pp.h"

int main(int argc, const char *argv[]) {
    // Create window
    ppBegin(640, 480, "pp", ppResizable);
    // Create bitmap for framebuffer
    Bitmap pbo;
    InitBitmap(&pbo, 320, 240);
    // Loop until window is closed
    while (ppPoll()) {
        // Clear bitmap
        FillBitmap(&pbo, Black);
        // Draw bitmap to window
        ppFlush(&pbo);
    }
    // Clean up
    DestroyBitmap(&pbo);
    ppEnd();
    return 0;
}
```

## Building

The easiest way is to drop ```pp.c``` and ```pp.h``` into your project and add the appropriate flags (Mac: ```-framework Cocoa```, Windows: ```-lgdi32``` and Linux: ```-lX11```). Or, run ```make library``` to build a dynamic library.

To build the live-reload app, run ```make all``` or ```make run```. This will build an executable and library in the ```build``` folder and then run the app. Edit ```examples/live.c```, and run ```make``` or ```make game```, and the program will automatically reload the changes. On Windows, run ```build.bat``` to build the live-reload app, and "rebuild.bat" to rebuild the library.

**NOTE**: The batch file uses the MSVC compiler, so Visual Studio or the [Visual Studio build tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022) must be installed. See [here](https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=msvc-170#developer_command_prompt_shortcuts) for more info.

## Credits

- .png loading and saving -- [erkkah/tigr](https://github.com/erkkah/tigr/) [UNLICENSE]
- Built-in debug font -- [dhepper/font8x8](https://github.com/dhepper/font8x8/blob/master/font8x8_basic.h) [Public Domain]
- win32/getopt.h for live editor -- [skandhurkat/Getopt-for-Visual-Studio](https://github.com/skandhurkat/Getopt-for-Visual-Studio) [GNU GPLv3]
- win32/dlfcn.[ch] for live editor -- [dlfcn-win32/dlfcn-win32](https://github.com/dlfcn-win32/dlfcn-win32) [MIT]
- Inspired by [this](https://nullprogram.com/blog/2014/12/23/) -- [skeeto/interactive-c-demo](https://github.com/skeeto/interactive-c-demo) [UNLICENSE]

## License
```
The MIT License (MIT)

Copyright (c) 2022 George Watson

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
