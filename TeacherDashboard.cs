using System;
using System.Data;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class TeacherDashboard : Form
    {
        private readonly int currentLecturerId;
        private DataGridView? dgv;
        private MenuStrip? menuStrip;
        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        public TeacherDashboard(int lecturerId)
        {
            InitializeComponent();
            currentLecturerId = lecturerId;
            InitializeCustomUI();
        }

        private void InitializeCustomUI()
        {
            this.Text = "Teacher Dashboard";
            this.Width = 900;
            this.Height = 600;

            // MenuStrip
            menuStrip = new MenuStrip();
            this.MainMenuStrip = menuStrip;
            this.Controls.Add(menuStrip);

            // Database Menu
            var databaseMenu = new ToolStripMenuItem("Database");
            menuStrip.Items.Add(databaseMenu);

            var viewGradesItem = new ToolStripMenuItem("View Grades", null, ViewGrades_Click);
            var addGradeItem = new ToolStripMenuItem("Add Grade", null, AddGrade_Click);
            var addStudentItem = new ToolStripMenuItem("Add Student", null, AddStudent_Click);
            var moveStudentItem = new ToolStripMenuItem("Move Student", null, MoveStudent_Click);
            var editScheduleItem = new ToolStripMenuItem("Edit Schedule", null, EditSchedule_Click);
            var changeStatusItem = new ToolStripMenuItem("Change Student Status", null, ChangeStatus_Click);
            var viewStudentsByGroupItem = new ToolStripMenuItem("View Students by Group", null, ViewStudentsByGroups_Click);
            var editGradesItem = new ToolStripMenuItem("Edit Student Grades", null, EditGrades_Click);
            var viewStudentInfoItem = new ToolStripMenuItem("View Student Info", null, ViewStudentInfo_Click);

            databaseMenu.DropDownItems.Add(viewGradesItem);
            databaseMenu.DropDownItems.Add(addGradeItem);
            databaseMenu.DropDownItems.Add(addStudentItem);
            databaseMenu.DropDownItems.Add(moveStudentItem);
            databaseMenu.DropDownItems.Add(new ToolStripSeparator());
            databaseMenu.DropDownItems.Add(editScheduleItem);
            databaseMenu.DropDownItems.Add(changeStatusItem);
            databaseMenu.DropDownItems.Add(viewStudentsByGroupItem);
            databaseMenu.DropDownItems.Add(editGradesItem);
            databaseMenu.DropDownItems.Add(new ToolStripSeparator());
            databaseMenu.DropDownItems.Add(viewStudentInfoItem);

            // Logout Menu
            var logoutMenu = new ToolStripMenuItem("Logout", null, Logout_Click);
            menuStrip.Items.Add(logoutMenu);

            // DataGridView
            dgv = new DataGridView()
            {
                Dock = DockStyle.Fill,
                ReadOnly = true,
                AllowUserToAddRows = false,
                AllowUserToDeleteRows = false,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            };
            this.Controls.Add(dgv);
            dgv.BringToFront();
        }

        // Opens the cascading grades form
        private void ViewGrades_Click(object? sender, EventArgs e)
        {
            var viewGradesForm = new TeacherViewGradesForm(currentLecturerId);
            viewGradesForm.ShowDialog();
        }

        private void AddGrade_Click(object? sender, EventArgs e)
        {
            var addGradeForm = new FormAddGrade(currentLecturerId);
            addGradeForm.ShowDialog();
        }

        private void AddStudent_Click(object? sender, EventArgs e)
        {
            var addStudentForm = new AddStudentForm();
            addStudentForm.ShowDialog();
        }

        private void MoveStudent_Click(object? sender, EventArgs e)
        {
            var moveStudentForm = new MoveStudentForm();
            moveStudentForm.ShowDialog();
        }

        private void EditSchedule_Click(object? sender, EventArgs e)
        {
            var editScheduleForm = new EditScheduleForm();
            editScheduleForm.ShowDialog();
        }

        private void ChangeStatus_Click(object? sender, EventArgs e)
        {
            var changeStatusForm = new ChangeStatusForm();
            changeStatusForm.ShowDialog();
        }

        private void ViewStudentsByGroups_Click(object? sender, EventArgs e)
        {
            var viewStudentsForm = new ViewStudentsByGroups();
            viewStudentsForm.ShowDialog();
        }

        private void EditGrades_Click(object? sender, EventArgs e)
        {
            var gradesForm = new EditStudentGradesForm("Admin");
            gradesForm.ShowDialog();
        }

        private void ViewStudentInfo_Click(object? sender, EventArgs e)
        {
            var viewStudentInfoForm = new ViewStudentInfoForm();
            viewStudentInfoForm.ShowDialog();
        }

        private void Logout_Click(object? sender, EventArgs e)
        {
            this.Close();
            var loginForm = new LoginForm();
            loginForm.Show();
        }
    }
}
