using System;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class RegisterForm : Form
    {
        private readonly string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        private TextBox textBoxUsername = new TextBox();
        private TextBox textBoxPassword = new TextBox();
        private TextBox textBoxRepeatPassword = new TextBox();
        private Button buttonRegister = new Button();

        public RegisterForm()
        {
            InitializeComponent();
            SetupUI();
        }

        private void SetupUI()
        {
            this.Text = "Register New Account";
            this.Size = new Size(400, 350);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = Color.White;

            Label labelUsername = new Label { Text = "Fak. No / Lecturer No:", Location = new Point(50, 50), AutoSize = true };
            textBoxUsername.Location = new Point(180, 45);
            textBoxUsername.Width = 150;

            Label labelPassword = new Label { Text = "Password:", Location = new Point(50, 90), AutoSize = true };
            textBoxPassword.Location = new Point(180, 85);
            textBoxPassword.Width = 150;
            textBoxPassword.UseSystemPasswordChar = true;

            Label labelRepeatPassword = new Label { Text = "Repeat Password:", Location = new Point(50, 130), AutoSize = true };
            textBoxRepeatPassword.Location = new Point(180, 125);
            textBoxRepeatPassword.Width = 150;
            textBoxRepeatPassword.UseSystemPasswordChar = true;

            buttonRegister.Text = "Register";
            buttonRegister.Location = new Point(150, 170);
            buttonRegister.Width = 100;
            buttonRegister.BackColor = Color.SteelBlue;
            buttonRegister.ForeColor = Color.White;
            buttonRegister.FlatStyle = FlatStyle.Flat;
            buttonRegister.FlatAppearance.BorderSize = 0;
            buttonRegister.Click += ButtonRegister_Click;

            Button buttonBack = new Button
            {
                Text = "Back",
                Location = new Point(10, this.ClientSize.Height - 40),
                Size = new Size(75, 30),
                Anchor = AnchorStyles.Bottom | AnchorStyles.Left
            };
            buttonBack.Click += (s, e) => { new LoginForm().Show(); this.Close(); };

            this.Controls.Add(labelUsername);
            this.Controls.Add(textBoxUsername);
            this.Controls.Add(labelPassword);
            this.Controls.Add(textBoxPassword);
            this.Controls.Add(labelRepeatPassword);
            this.Controls.Add(textBoxRepeatPassword);
            this.Controls.Add(buttonRegister);
            this.Controls.Add(buttonBack);
        }

        private void ButtonRegister_Click(object? sender, EventArgs e)
        {
            string username = textBoxUsername.Text.Trim();
            string password = textBoxPassword.Text;
            string repeat = textBoxRepeatPassword.Text;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                MessageBox.Show("Username and password required.");
                return;
            }

            if (password != repeat)
            {
                MessageBox.Show("Passwords do not match.");
                return;
            }

            string? role = null;
            int relatedId = -1;

            using (OracleConnection conn = new OracleConnection(connectionString))
            {
                try
                {
                    conn.Open();

                    // Check if username already exists
                    using (OracleCommand checkCmd = new OracleCommand(
                        "SELECT COUNT(*) FROM users WHERE username = :username", conn))
                    {
                        checkCmd.Parameters.Add("username", OracleDbType.Varchar2).Value = username;
                        int exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (exists > 0)
                        {
                            MessageBox.Show("Username already exists.");
                            return;
                        }
                    }

                    // Check if username matches lecturer number
                    using (OracleCommand cmdLecturer = new OracleCommand(
                        "SELECT lecturerid FROM lecturers WHERE lecturernom = :nom", conn))
                    {
                        cmdLecturer.Parameters.Add("nom", OracleDbType.Varchar2).Value = username;
                        object? result = cmdLecturer.ExecuteScalar();
                        if (result != null)
                        {
                            role = "teacher";
                            relatedId = Convert.ToInt32(result!); // ✅ null-forgiving operator
                        }
                    }

                    // If not lecturer, check if username matches student faknom
                    if (role == null)
                    {
                        using (OracleCommand cmdStudent = new OracleCommand(
                            "SELECT studentid FROM students WHERE facnom = :fak", conn))
                        {
                            cmdStudent.Parameters.Add("fak", OracleDbType.Varchar2).Value = username;
                            object? result = cmdStudent.ExecuteScalar();
                            if (result != null)
                            {
                                role = "student";
                                relatedId = Convert.ToInt32(result!); // ✅ null-forgiving operator
                            }
                        }
                    }

                    if (role == null)
                    {
                        MessageBox.Show("No matching lecturer or student found for this number.");
                        return;
                    }

                    string hashedPassword = PasswordHelper.HashPassword(password);

                    using (OracleCommand insertCmd = new OracleCommand(
                        "INSERT INTO users (userid, username, password, role) VALUES (users_seq.NEXTVAL, :username, :password, :role)", conn))
                    {
                        insertCmd.Parameters.Add("username", OracleDbType.Varchar2).Value = username;
                        insertCmd.Parameters.Add("password", OracleDbType.Varchar2).Value = hashedPassword;
                        insertCmd.Parameters.Add("role", OracleDbType.Varchar2).Value = role;
                        insertCmd.ExecuteNonQuery();
                    }

                    MessageBox.Show($"Registered successfully as {role}.");
                    new LoginForm().Show();
                    this.Close();
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }
        }
    }
}
