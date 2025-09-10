using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class CheckStudentGradesForm : Form
    {
        private readonly string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        private ComboBox comboBoxStudent = new ComboBox();
        private TextBox textBoxStudentName = new TextBox();
        private DataGridView dataGridViewGrades = new DataGridView();
        private Label labelName = new Label();

        public CheckStudentGradesForm()
        {
            SetupUI();
            LoadStudentList();
        }

        private void SetupUI()
        {
            this.Text = "Check Student Grades";
            this.Size = new Size(700, 150); // small initially
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;

            // ComboBox for selecting student
            Label labelStudent = new Label
            {
                Text = "Select Student (FacNum):",
                Location = new Point(30, 20),
                AutoSize = true,
                Font = new Font("Segoe UI", 10F, FontStyle.Bold)
            };

            comboBoxStudent.Location = new Point(200, 18);
            comboBoxStudent.Width = 150;
            comboBoxStudent.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBoxStudent.SelectedIndexChanged += ComboBoxStudent_SelectedIndexChanged;

            // Full name TextBox (hidden initially)
            labelName.Text = "Student Name:";
            labelName.Location = new Point(30, 55);
            labelName.AutoSize = true;
            labelName.Font = new Font("Segoe UI", 10F, FontStyle.Bold);
            labelName.Visible = false;

            textBoxStudentName.Location = new Point(200, 50);
            textBoxStudentName.Width = 250;
            textBoxStudentName.ReadOnly = true;
            textBoxStudentName.Visible = false;

            // DataGridView (hidden initially)
            dataGridViewGrades.Location = new Point(30, 90);
            dataGridViewGrades.Size = new Size(620, 250);
            dataGridViewGrades.ReadOnly = true;
            dataGridViewGrades.AllowUserToAddRows = false;
            dataGridViewGrades.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dataGridViewGrades.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dataGridViewGrades.Visible = false;

            // Add controls
            this.Controls.Add(labelStudent);
            this.Controls.Add(comboBoxStudent);
            this.Controls.Add(labelName);
            this.Controls.Add(textBoxStudentName);
            this.Controls.Add(dataGridViewGrades);
        }

        private void LoadStudentList()
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string sql = @"SELECT STUDENTID, FACNOM 
                               FROM STUDENTS 
                               ORDER BY FACNOM";

                using var cmd = new OracleCommand(sql, conn);
                using var reader = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(reader);

                comboBoxStudent.DataSource = dt;
                comboBoxStudent.DisplayMember = "FACNOM";
                comboBoxStudent.ValueMember = "STUDENTID";
                comboBoxStudent.SelectedIndex = -1; // nothing selected initially
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading students: " + ex.Message);
            }
        }

        private void ComboBoxStudent_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (comboBoxStudent.SelectedIndex == -1) return;

            int studentId = Convert.ToInt32(comboBoxStudent.SelectedValue);
            ShowStudentName(studentId);
            LoadGrades(studentId);

            // Show hidden controls after selecting a student
            labelName.Visible = true;
            textBoxStudentName.Visible = true;
            dataGridViewGrades.Visible = true;

            // Resize form to fit DataGridView
            this.Size = new Size(700, 400);
        }

        private void ShowStudentName(int studentId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string sql = @"SELECT FIRSTNAME || ' ' || LASTNAME AS FullName 
                               FROM STUDENTS 
                               WHERE STUDENTID = :studentid";

                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("studentid", studentId);

                object result = cmd.ExecuteScalar();
                textBoxStudentName.Text = result?.ToString() ?? "";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error fetching student name: " + ex.Message);
            }
        }

        private void LoadGrades(int studentId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string sql = @"
                    SELECT p.name AS Subject, o.grade AS Grade, o.""Date"" AS Date
                    FROM OCENKI o
                    JOIN PREDMETI p ON o.subjectid = p.subjectid
                    WHERE o.studentid = :studentid
                    ORDER BY o.""Date"" DESC";

                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("studentid", studentId);

                using var reader = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(reader);

                dataGridViewGrades.DataSource = dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading grades: " + ex.Message);
            }
        }
    }
}
