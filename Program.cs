using System;
using System.Windows.Forms;

namespace InternshipProjectStatusDB
{
    internal static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.SetHighDpiMode(HighDpiMode.SystemAware);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            // Start with LoginForm
            Application.Run(new LoginForm());
        }
    }
}
