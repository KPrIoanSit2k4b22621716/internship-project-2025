using System;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class ResetPasswordForm : Form
    {
        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        private TextBox textBoxUsername = null!;
        private TextBox textBoxNewPassword = null!;
        private Button buttonReset = null!;

        public ResetPasswordForm()
        {
            InitializeComponent();
            SetupUI();
        }

        private void SetupUI()
        {
            this.Text = "Reset Password";
            this.Size = new System.Drawing.Size(350, 250);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;

            Label lblUser = new Label { Text = "Username:", Location = new System.Drawing.Point(30, 30), AutoSize = true };
            textBoxUsername = new TextBox { Location = new System.Drawing.Point(130, 25), Width = 160 };

            Label lblNew = new Label { Text = "New Password:", Location = new System.Drawing.Point(30, 80), AutoSize = true };
            textBoxNewPassword = new TextBox { Location = new System.Drawing.Point(130, 75), Width = 160, UseSystemPasswordChar = true };

            buttonReset = new Button { Text = "Reset Password", Location = new System.Drawing.Point(130, 130), Width = 120 };
            buttonReset.Click += ButtonReset_Click;

            this.Controls.Add(lblUser);
            this.Controls.Add(textBoxUsername);
            this.Controls.Add(lblNew);
            this.Controls.Add(textBoxNewPassword);
            this.Controls.Add(buttonReset);
        }

        private void ButtonReset_Click(object? sender, EventArgs e)
        {
            string username = textBoxUsername.Text.Trim();
            string newPassword = textBoxNewPassword.Text;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(newPassword))
            {
                MessageBox.Show("Username and new password required.");
                return;
            }

            string hashedPassword = PasswordHelper.HashPassword(newPassword);

            using (OracleConnection conn = new OracleConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    OracleCommand cmd = new OracleCommand("UPDATE users SET password = :password WHERE username = :username", conn);
                    cmd.Parameters.Add("password", OracleDbType.Varchar2).Value = hashedPassword;
                    cmd.Parameters.Add("username", OracleDbType.Varchar2).Value = username;

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0) MessageBox.Show("Password reset successfully.");
                    else MessageBox.Show("Username not found.");
                }
                catch (Exception ex) { MessageBox.Show("Error: " + ex.Message); }
            }
        }
    }
}
