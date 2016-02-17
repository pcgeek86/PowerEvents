using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using System.Security.Principal;

namespace WmiEventHelper
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            if (CheckAdmin())
            {
                Application.Run(new FormWmiEventHelper());
            }
            else
            {
                MessageBox.Show("You are not an administrator. Please run this application as an administrator.");
            }
        }

        private static bool CheckAdmin()
        {
            WindowsIdentity identity = WindowsIdentity.GetCurrent();
            WindowsPrincipal principal = new WindowsPrincipal(identity);
            bool IsAdmin = principal.IsInRole(WindowsBuiltInRole.Administrator);
            return IsAdmin;
        }
    }
}
