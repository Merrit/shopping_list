#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "run_loop.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  RunLoop run_loop;

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(&run_loop, project);

/* ------------------- Set custom window size and position ------------------ */

  // Set the initial window size.
  int kFlutterWindowWidth = 400;
  int kFlutterWindowHeight = 700;
  Win32Window::Size size(kFlutterWindowWidth, kFlutterWindowHeight);
  // Set the initial window position to center of screen.
  int x = (GetSystemMetrics(SM_CXSCREEN) / 2) - (kFlutterWindowWidth / 2);
  int y = (GetSystemMetrics(SM_CYSCREEN) / 2) - (kFlutterWindowHeight / 2);
  Win32Window::Point origin(x, y);

/* ---------------------- End custom size and position ---------------------- */

  if (!window.CreateAndShow(L"shopping_list", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  run_loop.Run();

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
