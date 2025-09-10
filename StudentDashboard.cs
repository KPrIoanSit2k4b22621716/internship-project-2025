using System;
using System.Drawing;
using System.Windows.Forms;

namespace InternshipProjectStatusDB
{
    public partial class StudentDashboard : Form
    {
        private readonly int studentId;
        private readonly string firstName;
        private readonly string lastName;

        private Label lblWelcome = null!;
        private Button btnPersonalInfo = null!;
        private Button btnGrades = null!;
        private Button btnSchedule = null!;
        private Button btnLogout = null!;

        public StudentDashboard(int studentId, string firstName, string lastName)
        {
            this.studentId = studentId;
            this.firstName = firstName;
            this.lastName = lastName;

            InitializeComponent();
            SetupUI();
        }

        private void SetupUI()
        {
            this.Text = "Student Dashboard";
            this.Size = new Size(500, 300);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = Color.White;

            // Welcome Label
            lblWelcome = new Label
            {
                Text = $"Welcome, {firstName} {lastName}!",
                Location = new Point(20, 20),
                AutoSize = true,
                Font = new Font("Segoe UI", 12F, FontStyle.Bold)
            };
            this.Controls.Add(lblWelcome);

            // Personal Info Button
            btnPersonalInfo = new Button
            {
                Text = "Personal Info",
                Location = new Point(20, 70),
                Size = new Size(150, 40),
                BackColor = Color.SteelBlue,
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat
            };
            btnPersonalInfo.Click += BtnPersonalInfo_Click;
            this.Controls.Add(btnPersonalInfo);

            // Grades Button
            btnGrades = new Button
            {
                Text = "Grades",
                Location = new Point(200, 70),
                Size = new Size(150, 40),
                BackColor = Color.MediumSeaGreen,
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat
            };
            btnGrades.Click += BtnGrades_Click;
            this.Controls.Add(btnGrades);

            // Schedule Button (below Grades)
            btnSchedule = new Button
            {
                Text = "Schedule",
                Location = new Point(200, 120), // below Grades
                Size = new Size(150, 40),
                BackColor = Color.MediumPurple,
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat
            };
            btnSchedule.Click += BtnSchedule_Click;
            this.Controls.Add(btnSchedule);

            // Logout Button (below Personal Info)
            btnLogout = new Button
            {
                Text = "Logout",
                Location = new Point(20, 120), // below Personal Info
                Size = new Size(150, 40),
                BackColor = Color.IndianRed,
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat
            };
            btnLogout.Click += BtnLogout_Click;
            this.Controls.Add(btnLogout);
        }

        private void BtnPersonalInfo_Click(object? sender, EventArgs e)
        {
            var personalInfoForm = new StudentPersonalInfoForm(studentId);
            personalInfoForm.ShowDialog();
        }

        private void BtnGrades_Click(object? sender, EventArgs e)
        {
            var gradesForm = new StudentGradesForm(studentId);
            gradesForm.ShowDialog();
        }

        private void BtnSchedule_Click(object? sender, EventArgs e)
        {
            var scheduleForm = new StudentScheduleForm(studentId);
            scheduleForm.ShowDialog();
        }

        private void BtnLogout_Click(object? sender, EventArgs e)
        {
            this.Hide();
            new LoginForm().Show();
        }
    }
}
