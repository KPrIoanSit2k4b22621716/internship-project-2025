using System;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class LoginForm : Form
    {
        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        // UI Controls initialized upfront
        private Label titleLabel = new Label();
        private Label labelUsername = new Label();
        private Label labelPassword = new Label();
        private TextBox textBoxUsername = new TextBox();
        private TextBox textBoxPassword = new TextBox();
        private CheckBox checkBoxShowPassword = new CheckBox();
        private Button buttonLogin = new Button();
        private Button buttonRegister = new Button();
        private LinkLabel linkForgotPassword = new LinkLabel();

        public LoginForm()
        {
            InitializeComponent();
            SetupCustomUI();
        }

        private void SetupCustomUI()
        {
            // Form settings
            this.Text = "Login";
            this.Size = new Size(400, 350);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.BackColor = Color.White;

            // Title
            titleLabel.Text = "Technical University of Varna\nStatus";
            titleLabel.Font = new Font("Segoe UI", 14F, FontStyle.Bold);
            titleLabel.ForeColor = Color.DarkBlue;
            titleLabel.AutoSize = true;
            titleLabel.TextAlign = ContentAlignment.MiddleCenter;
            titleLabel.Location = new Point(
                (this.ClientSize.Width - titleLabel.PreferredWidth) / 2,
                20
            );

            // Username Label & TextBox
            labelUsername.Text = "Username:";
            labelUsername.Location = new Point(30, 80);
            labelUsername.AutoSize = true;
            labelUsername.ForeColor = Color.DarkBlue;
            labelUsername.Font = new Font("Segoe UI", 10F, FontStyle.Bold);

            textBoxUsername.Location = new Point(150, 75);
            textBoxUsername.Width = 180;

            // Password Label & TextBox
            labelPassword.Text = "Password:";
            labelPassword.Location = new Point(30, 130);
            labelPassword.AutoSize = true;
            labelPassword.ForeColor = Color.DarkBlue;
            labelPassword.Font = new Font("Segoe UI", 10F, FontStyle.Bold);

            textBoxPassword.Location = new Point(150, 125);
            textBoxPassword.Width = 180;
            textBoxPassword.UseSystemPasswordChar = true;

            // Show Password Checkbox
            checkBoxShowPassword.Text = "Show Password";
            checkBoxShowPassword.Location = new Point(150, 155);
            checkBoxShowPassword.AutoSize = true;
            checkBoxShowPassword.CheckedChanged += CheckBoxShowPassword_CheckedChanged;

            // Login Button
            buttonLogin.Text = "Login";
            buttonLogin.Location = new Point(80, 200);
            buttonLogin.Width = 100;
            buttonLogin.BackColor = Color.SteelBlue;
            buttonLogin.ForeColor = Color.White;
            buttonLogin.FlatStyle = FlatStyle.Flat;
            buttonLogin.Click += ButtonLogin_Click;

            // Register Button
            buttonRegister.Text = "Register";
            buttonRegister.Location = new Point(200, 200);
            buttonRegister.Width = 100;
            buttonRegister.BackColor = Color.SteelBlue;
            buttonRegister.ForeColor = Color.White;
            buttonRegister.FlatStyle = FlatStyle.Flat;
            buttonRegister.Click += ButtonRegister_Click;

            // Forgot Password Link
            linkForgotPassword.Text = "Forgot Password?";
            linkForgotPassword.Location = new Point(150, 240);
            linkForgotPassword.AutoSize = true;
            linkForgotPassword.LinkColor = Color.DarkBlue;
            linkForgotPassword.Click += LinkForgotPassword_Click;

            // Add controls to form
            this.Controls.Add(titleLabel);
            this.Controls.Add(labelUsername);
            this.Controls.Add(textBoxUsername);
            this.Controls.Add(labelPassword);
            this.Controls.Add(textBoxPassword);
            this.Controls.Add(checkBoxShowPassword);
            this.Controls.Add(buttonLogin);
            this.Controls.Add(buttonRegister);
            this.Controls.Add(linkForgotPassword);
        }

        private void ButtonLogin_Click(object? sender, EventArgs e)
        {
            string username = textBoxUsername.Text.Trim();
            string password = textBoxPassword.Text;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                MessageBox.Show("Please enter username and password.");
                return;
            }

            string hashedInput = PasswordHelper.HashPassword(password);

            try
            {
                using (var conn = new OracleConnection(connectionString))
                {
                    conn.Open();

                    // Check role and password from users table
                    string queryUser = "SELECT role, userid, password FROM users WHERE username = :username";
                    using (var cmd = new OracleCommand(queryUser, conn))
                    {
                        cmd.Parameters.Add("username", OracleDbType.Varchar2).Value = username;

                        using var reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            string storedHash = reader.GetString(reader.GetOrdinal("password"));
                            string role = reader.GetString(reader.GetOrdinal("role"));

                            if (storedHash != hashedInput)
                            {
                                MessageBox.Show("Invalid username or password.");
                                return;
                            }

                            this.Hide();

                            if (role.Equals("teacher", StringComparison.OrdinalIgnoreCase))
                            {
                                // Get lecturer info by lecturernom
                                string firstName = "";
                                string lastName = "";
                                int lecturerId = 0;

                                string queryLecturer = "SELECT lecturerid, firstname, lastname FROM lecturers WHERE lecturernom = :lecturernom";
                                using (var cmdLect = new OracleCommand(queryLecturer, conn))
                                {
                                    cmdLect.Parameters.Add("lecturernom", OracleDbType.Varchar2).Value = username;
                                    using var lectReader = cmdLect.ExecuteReader();
                                    if (lectReader.Read())
                                    {
                                        lecturerId = lectReader.GetInt32(lectReader.GetOrdinal("lecturerid"));
                                        firstName = lectReader.GetString(lectReader.GetOrdinal("firstname"));
                                        lastName = lectReader.GetString(lectReader.GetOrdinal("lastname"));
                                    }
                                }

                                MessageBox.Show($"Welcome, {firstName} {lastName}! Your lecturernom: {username}");
                                new TeacherDashboard(lecturerId).ShowDialog();
                            }
                            else if (role.Equals("student", StringComparison.OrdinalIgnoreCase))
                            {
                                // Get student info by facnom
                                string firstName = "";
                                string lastName = "";
                                int studentId = 0;

                                string queryStudent = "SELECT studentid, firstname, lastname FROM students WHERE facnom = :facnom";
                                using (var cmdStudent = new OracleCommand(queryStudent, conn))
                                {
                                    cmdStudent.Parameters.Add("facnom", OracleDbType.Varchar2).Value = username;
                                    using var studentReader = cmdStudent.ExecuteReader();
                                    if (studentReader.Read())
                                    {
                                        studentId = studentReader.GetInt32(studentReader.GetOrdinal("studentid"));
                                        firstName = studentReader.GetString(studentReader.GetOrdinal("firstname"));
                                        lastName = studentReader.GetString(studentReader.GetOrdinal("lastname"));
                                    }
                                    else
                                    {
                                        MessageBox.Show("Student not found.");
                                        return;
                                    }
                                }

                                MessageBox.Show($"Welcome, {firstName} {lastName}! Your facnom: {username}");

                                // Pass all required parameters to StudentDashboard
                                new StudentDashboard(studentId, username, firstName + " " + lastName).ShowDialog();
                            }

                            else
                            {
                                MessageBox.Show("Unknown user role.");
                            }

                            this.Show();
                        }
                        else
                        {
                            MessageBox.Show("Invalid username or password.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error connecting to database: " + ex.Message);
            }
        }

        private void CheckBoxShowPassword_CheckedChanged(object? sender, EventArgs e)
        {
            textBoxPassword.UseSystemPasswordChar = !checkBoxShowPassword.Checked;
        }

        private void ButtonRegister_Click(object? sender, EventArgs e)
        {
            new RegisterForm().Show();
            this.Hide();
        }

        private void LinkForgotPassword_Click(object? sender, EventArgs e)
        {
            using (var resetForm = new ResetPasswordForm())
            {
                resetForm.ShowDialog();
            }
        }
    }
}
