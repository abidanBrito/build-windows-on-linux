#include <windows.h>

namespace
{
    auto CALLBACK window_proc(HWND window, UINT message, WPARAM wparam, LPARAM lparam) -> LRESULT
    {
        switch (message)
        {
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
        default:
            return DefWindowProcW(window, message, wparam, lparam);
        }
    }
} // namespace

auto WINAPI wWinMain(HINSTANCE instance, HINSTANCE /*unused*/, PWSTR /*unused*/, int show) -> int
{
    constexpr auto class_name = L"build-windows-on-linux";

    // Describe the window
    WNDCLASSW window_class = {};
    window_class.lpfnWndProc = window_proc;
    window_class.hInstance = instance;
    window_class.hCursor = LoadCursorW(nullptr, IDC_ARROW);
    window_class.hbrBackground = CreateSolidBrush(RGB(128, 128, 128));
    window_class.lpszClassName = class_name;

    RegisterClassW(&window_class);

    // Create the window
    HWND window = CreateWindowExW(0, class_name, L"Hey sailor!", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,
                                  CW_USEDEFAULT, 640, 480, nullptr, nullptr, instance, nullptr);
    if (window == nullptr)
    {
        return 1;
    }

    ShowWindow(window, show);

    // Event loop
    MSG message;
    while (GetMessageW(&message, nullptr, 0, 0) > 0)
    {
        TranslateMessage(&message);
        DispatchMessageW(&message);
    }

    return static_cast<int>(message.wParam);
}
