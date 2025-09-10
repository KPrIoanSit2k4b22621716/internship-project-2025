using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class TeacherViewGradesForm : Form
    {
        private readonly string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";
        private readonly int currentLecturerId;

        private ComboBox cmbFaculty = new ComboBox();
        private ComboBox cmbSpecialty = new ComboBox();
        private ComboBox cmbKurs = new ComboBox();
        private ComboBox cmbGroup = new ComboBox();
        private ComboBox cmbStudent = new ComboBox();
        private DataGridView dgvGrades = new DataGridView();

        public TeacherViewGradesForm(int lecturerId)
        {
            currentLecturerId = lecturerId;
            InitializeUI();
            LoadFaculties();
        }

        private void InitializeUI()
        {
            this.Text = "View Student Grades";
            this.Size = new Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;

            Label lblFaculty = new Label { Text = "Faculty:", Location = new Point(20, 20), AutoSize = true };
            cmbFaculty.Location = new Point(100, 20); cmbFaculty.Width = 180;
            cmbFaculty.DropDownStyle = ComboBoxStyle.DropDownList;
            cmbFaculty.SelectedIndexChanged += CmbFaculty_SelectedIndexChanged;

            Label lblSpecialty = new Label { Text = "Specialty:", Location = new Point(300, 20), AutoSize = true };
            cmbSpecialty.Location = new Point(380, 20); cmbSpecialty.Width = 180;
            cmbSpecialty.DropDownStyle = ComboBoxStyle.DropDownList;
            cmbSpecialty.SelectedIndexChanged += CmbSpecialty_SelectedIndexChanged;

            Label lblKurs = new Label { Text = "Kurs:", Location = new Point(580, 20), AutoSize = true };
            cmbKurs.Location = new Point(620, 20); cmbKurs.Width = 100;
            cmbKurs.DropDownStyle = ComboBoxStyle.DropDownList;
            cmbKurs.SelectedIndexChanged += CmbKurs_SelectedIndexChanged;

            Label lblGroup = new Label { Text = "Group:", Location = new Point(20, 60), AutoSize = true };
            cmbGroup.Location = new Point(100, 60); cmbGroup.Width = 180;
            cmbGroup.DropDownStyle = ComboBoxStyle.DropDownList;
            cmbGroup.SelectedIndexChanged += CmbGroup_SelectedIndexChanged;

            Label lblStudent = new Label { Text = "Student:", Location = new Point(300, 60), AutoSize = true };
            cmbStudent.Location = new Point(380, 60); cmbStudent.Width = 180;
            cmbStudent.DropDownStyle = ComboBoxStyle.DropDownList;
            cmbStudent.SelectedIndexChanged += CmbStudent_SelectedIndexChanged;

            dgvGrades.Location = new Point(20, 100);
            dgvGrades.Size = new Size(840, 400);
            dgvGrades.ReadOnly = true;
            dgvGrades.AllowUserToAddRows = false;
            dgvGrades.AllowUserToDeleteRows = false;
            dgvGrades.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvGrades.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;

            this.Controls.Add(lblFaculty);
            this.Controls.Add(cmbFaculty);
            this.Controls.Add(lblSpecialty);
            this.Controls.Add(cmbSpecialty);
            this.Controls.Add(lblKurs);
            this.Controls.Add(cmbKurs);
            this.Controls.Add(lblGroup);
            this.Controls.Add(cmbGroup);
            this.Controls.Add(lblStudent);
            this.Controls.Add(cmbStudent);
            this.Controls.Add(dgvGrades);
        }

        private void LoadFaculties()
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string query = "SELECT fakultetid, fullname FROM fakulteti ORDER BY fullname";
                using var cmd = new OracleCommand(query, conn);
                using var reader = cmd.ExecuteReader();

                cmbFaculty.Items.Clear();
                while (reader.Read())
                {
                    cmbFaculty.Items.Add(new ComboboxItem(reader["fullname"].ToString()!, reader.GetInt32(0)));
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading faculties: " + ex.Message);
            }
        }

        private void CmbFaculty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cmbFaculty.SelectedItem is ComboboxItem faculty)
            {
                LoadSpecialties(faculty.Value);
            }
        }

        private void LoadSpecialties(int facultyId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string query = "SELECT specid, name FROM specialnosti WHERE fakultetid = :facultyId ORDER BY name";
                using var cmd = new OracleCommand(query, conn);
                cmd.Parameters.Add("facultyId", OracleDbType.Int32).Value = facultyId;

                using var reader = cmd.ExecuteReader();
                cmbSpecialty.Items.Clear();
                while (reader.Read())
                {
                    cmbSpecialty.Items.Add(new ComboboxItem(reader["name"].ToString()!, reader.GetInt32(0)));
                }

                cmbKurs.Items.Clear();
                cmbGroup.Items.Clear();
                cmbStudent.Items.Clear();
                dgvGrades.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading specialties: " + ex.Message);
            }
        }

        private void CmbSpecialty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cmbSpecialty.SelectedItem is ComboboxItem specialty)
            {
                LoadKurs(specialty.Value);
            }
        }

        private void LoadKurs(int specId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string query = "SELECT DISTINCT kurs FROM grupi WHERE specid = :specId ORDER BY kurs";
                using var cmd = new OracleCommand(query, conn);
                cmd.Parameters.Add("specId", OracleDbType.Int32).Value = specId;

                using var reader = cmd.ExecuteReader();
                cmbKurs.Items.Clear();
                while (reader.Read())
                {
                    cmbKurs.Items.Add(reader.GetInt32(0).ToString());
                }

                cmbGroup.Items.Clear();
                cmbStudent.Items.Clear();
                dgvGrades.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading kurs: " + ex.Message);
            }
        }

        private void CmbKurs_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cmbSpecialty.SelectedItem is ComboboxItem specialty && int.TryParse(cmbKurs.SelectedItem?.ToString(), out int kurs))
            {
                LoadGroups(specialty.Value, kurs);
            }
        }

        private void LoadGroups(int specId, int kurs)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string query = "SELECT groupid, name FROM grupi WHERE specid = :specId AND kurs = :kurs ORDER BY name";
                using var cmd = new OracleCommand(query, conn);
                cmd.Parameters.Add("specId", OracleDbType.Int32).Value = specId;
                cmd.Parameters.Add("kurs", OracleDbType.Int32).Value = kurs;

                using var reader = cmd.ExecuteReader();
                cmbGroup.Items.Clear();
                while (reader.Read())
                {
                    cmbGroup.Items.Add(new ComboboxItem(reader["name"].ToString()!, reader.GetInt32(0)));
                }

                cmbStudent.Items.Clear();
                dgvGrades.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading groups: " + ex.Message);
            }
        }

        private void CmbGroup_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cmbGroup.SelectedItem is ComboboxItem group)
            {
                LoadStudents(group.Value);
            }
        }

        private void LoadStudents(int groupId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string query = "SELECT studentid, firstname || ' ' || lastname AS fullname FROM students WHERE groupid = :groupId ORDER BY lastname";
                using var cmd = new OracleCommand(query, conn);
                cmd.Parameters.Add("groupId", OracleDbType.Int32).Value = groupId;

                using var reader = cmd.ExecuteReader();
                cmbStudent.Items.Clear();
                while (reader.Read())
                {
                    cmbStudent.Items.Add(new ComboboxItem(reader["fullname"].ToString()!, reader.GetInt32(0)));
                }

                dgvGrades.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading students: " + ex.Message);
            }
        }

        private void CmbStudent_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cmbStudent.SelectedItem is ComboboxItem student)
            {
                LoadGrades(student.Value);
            }
        }

        private void LoadGrades(int studentId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string query = @"
                    SELECT 
                        p.name AS Subject,
                        o.grade AS Grade,
                        o.grade_date AS GradeDate,
                        l.firstname || ' ' || l.lastname AS Lecturer
                    FROM ocenki o
                    JOIN predmeti p ON o.subjectid = p.subjectid
                    JOIN lecturers l ON o.lecturerid = l.lecturerid
                    WHERE o.studentid = :studentId
                    ORDER BY o.grade_date DESC";

                using var cmd = new OracleCommand(query, conn);
                cmd.Parameters.Add("studentId", OracleDbType.Int32).Value = studentId;

                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                dgvGrades.DataSource = dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading grades: " + ex.Message);
            }
        }
    }

    // Helper class for ComboBox items
    public class ComboboxItem
    {
        public string Text { get; set; }
        public int Value { get; set; }
        public ComboboxItem(string text, int value)
        {
            Text = text;
            Value = value;
        }
        public override string ToString() => Text;
    }
}
