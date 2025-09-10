using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class FormAddGrade : Form
    {
        private readonly int _lecturerId;
        private readonly string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        private ComboBox comboBoxFaculty = new ComboBox();
        private ComboBox comboBoxSpecialty = new ComboBox();
        private ComboBox comboBoxKurs = new ComboBox();
        private ComboBox comboBoxGroup = new ComboBox();
        private ComboBox comboBoxStudent = new ComboBox();
        private ComboBox comboBoxSubject = new ComboBox();
        private ComboBox comboBoxGrade = new ComboBox();
        private DateTimePicker dateTimePicker1 = new DateTimePicker();
        private Button buttonSave = new Button();

        public FormAddGrade(int lecturerId)
        {
            _lecturerId = lecturerId;
            InitializeComponent();
            SetupCustomUI();
            LoadFaculties();
            LoadGrades();
        }

        private void SetupCustomUI()
        {
            this.Text = "Add Grade";
            this.Size = new Size(500, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.BackColor = Color.White;

            int labelX = 30;
            int comboX = 180;
            int startY = 30;
            int spacing = 40;

            void AddLabelAndCombo(string labelText, ComboBox combo, int y)
            {
                Label lbl = new Label
                {
                    Text = labelText,
                    Location = new Point(labelX, y),
                    AutoSize = true,
                    ForeColor = Color.DarkBlue,
                    Font = new Font("Segoe UI", 10F, FontStyle.Bold)
                };
                combo.Location = new Point(comboX, y - 3);
                combo.Width = 250;
                combo.DropDownStyle = ComboBoxStyle.DropDownList;
                this.Controls.Add(lbl);
                this.Controls.Add(combo);
            }

            AddLabelAndCombo("Faculty:", comboBoxFaculty, startY);
            AddLabelAndCombo("Specialty:", comboBoxSpecialty, startY + spacing);
            AddLabelAndCombo("Kurs:", comboBoxKurs, startY + spacing * 2);
            AddLabelAndCombo("Group:", comboBoxGroup, startY + spacing * 3);
            AddLabelAndCombo("Student (FACNOM):", comboBoxStudent, startY + spacing * 4);
            AddLabelAndCombo("Subject:", comboBoxSubject, startY + spacing * 5);

            // Grade
            Label lblGrade = new Label
            {
                Text = "Grade:",
                Location = new Point(labelX, startY + spacing * 6),
                AutoSize = true,
                ForeColor = Color.DarkBlue,
                Font = new Font("Segoe UI", 10F, FontStyle.Bold)
            };
            comboBoxGrade.Location = new Point(comboX, startY + spacing * 6 - 3);
            comboBoxGrade.Width = 250;
            comboBoxGrade.DropDownStyle = ComboBoxStyle.DropDownList;
            this.Controls.Add(lblGrade);
            this.Controls.Add(comboBoxGrade);

            // Date
            Label lblDate = new Label
            {
                Text = "Date:",
                Location = new Point(labelX, startY + spacing * 7),
                AutoSize = true,
                ForeColor = Color.DarkBlue,
                Font = new Font("Segoe UI", 10F, FontStyle.Bold)
            };
            dateTimePicker1.Location = new Point(comboX, startY + spacing * 7 - 3);
            dateTimePicker1.Width = 250;
            dateTimePicker1.Format = DateTimePickerFormat.Short;
            this.Controls.Add(lblDate);
            this.Controls.Add(dateTimePicker1);

            // Save Button
            buttonSave.Text = "Save Grade";
            buttonSave.Location = new Point(comboX, startY + spacing * 8);
            buttonSave.Width = 150;
            buttonSave.BackColor = Color.SteelBlue;
            buttonSave.ForeColor = Color.White;
            buttonSave.FlatStyle = FlatStyle.Flat;
            buttonSave.Click += ButtonSave_Click;
            this.Controls.Add(buttonSave);

            // Event handlers for cascading
            comboBoxFaculty.SelectedIndexChanged += ComboBoxFaculty_SelectedIndexChanged;
            comboBoxSpecialty.SelectedIndexChanged += ComboBoxSpecialty_SelectedIndexChanged;
            comboBoxKurs.SelectedIndexChanged += ComboBoxKurs_SelectedIndexChanged;
            comboBoxGroup.SelectedIndexChanged += ComboBoxGroup_SelectedIndexChanged;

            // Student autocomplete
            comboBoxStudent.DropDownStyle = ComboBoxStyle.DropDown;
            comboBoxStudent.AutoCompleteMode = AutoCompleteMode.SuggestAppend;
            comboBoxStudent.AutoCompleteSource = AutoCompleteSource.ListItems;
        }

        private void LoadFaculties()
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                var cmd = new OracleCommand("SELECT FAKULTETID, FULLNAME FROM FAKULTETI ORDER BY FULLNAME", conn);
                var reader = cmd.ExecuteReader();
                var dt = new DataTable();
                dt.Load(reader);

                comboBoxFaculty.DataSource = dt;
                comboBoxFaculty.DisplayMember = "FULLNAME";
                comboBoxFaculty.ValueMember = "FAKULTETID";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading faculties: " + ex.Message);
            }
        }

        private void ComboBoxFaculty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (comboBoxFaculty.SelectedItem is not DataRowView drv) return;
            int facultyId = Convert.ToInt32(drv["FAKULTETID"]);

            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                var cmd = new OracleCommand("SELECT SPECID, NAME FROM SPECIALNOSTI WHERE FAKULTETID = :fid ORDER BY NAME", conn);
                cmd.Parameters.Add("fid", facultyId);
                var reader = cmd.ExecuteReader();
                var dt = new DataTable();
                dt.Load(reader);

                comboBoxSpecialty.DataSource = dt;
                comboBoxSpecialty.DisplayMember = "NAME";
                comboBoxSpecialty.ValueMember = "SPECID";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading specialties: " + ex.Message);
            }
        }

        private void ComboBoxSpecialty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (comboBoxSpecialty.SelectedItem is not DataRowView drv) return;
            int specId = Convert.ToInt32(drv["SPECID"]);

            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                var cmd = new OracleCommand("SELECT DISTINCT KURS FROM GRUPI WHERE SPECID = :sid ORDER BY KURS", conn);
                cmd.Parameters.Add("sid", specId);
                var reader = cmd.ExecuteReader();
                var dt = new DataTable();
                dt.Load(reader);

                comboBoxKurs.DataSource = dt;
                comboBoxKurs.DisplayMember = "KURS";
                comboBoxKurs.ValueMember = "KURS";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading kurs: " + ex.Message);
            }
        }

        private void ComboBoxKurs_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (comboBoxKurs.SelectedItem is not DataRowView drv) return;
            int kurs = Convert.ToInt32(drv["KURS"]);
            if (comboBoxSpecialty.SelectedItem is not DataRowView drvSpec) return;
            int specId = Convert.ToInt32(drvSpec["SPECID"]);

            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                var cmd = new OracleCommand("SELECT GROUPID, NAME FROM GRUPI WHERE SPECID = :sid AND KURS = :kurs ORDER BY NAME", conn);
                cmd.Parameters.Add("sid", specId);
                cmd.Parameters.Add("kurs", kurs);
                var reader = cmd.ExecuteReader();
                var dt = new DataTable();
                dt.Load(reader);

                comboBoxGroup.DataSource = dt;
                comboBoxGroup.DisplayMember = "NAME";
                comboBoxGroup.ValueMember = "GROUPID";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading groups: " + ex.Message);
            }
        }

        private void ComboBoxGroup_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (comboBoxGroup.SelectedItem is not DataRowView drv) return;
            int groupId = Convert.ToInt32(drv["GROUPID"]);

            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                var cmd = new OracleCommand("SELECT STUDENTID, FACNOM FROM STUDENTS WHERE GROUPID = :gid ORDER BY FACNOM", conn);
                cmd.Parameters.Add("gid", groupId);
                var reader = cmd.ExecuteReader();
                var dt = new DataTable();
                dt.Load(reader);

                comboBoxStudent.DataSource = dt;
                comboBoxStudent.DisplayMember = "FACNOM";
                comboBoxStudent.ValueMember = "STUDENTID";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading students: " + ex.Message);
            }

            // Load subjects for this group/spec
            LoadSubjectsForSpecialtyAndLecturer();
        }

        private void LoadSubjectsForSpecialtyAndLecturer()
        {
            if (comboBoxSpecialty.SelectedItem is not DataRowView drvSpec) return;
            int specId = Convert.ToInt32(drvSpec["SPECID"]);

            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                var cmd = new OracleCommand("SELECT SUBJECTID, NAME FROM PREDMETI WHERE SPECID = :sid ORDER BY NAME", conn);
                cmd.Parameters.Add("sid", specId);
                var reader = cmd.ExecuteReader();
                var dt = new DataTable();
                dt.Load(reader);

                comboBoxSubject.DataSource = dt;
                comboBoxSubject.DisplayMember = "NAME";
                comboBoxSubject.ValueMember = "SUBJECTID";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading subjects: " + ex.Message);
            }
        }

        private void LoadGrades()
        {
            comboBoxGrade.Items.Clear();
            comboBoxGrade.Items.Add("1 - Not attending");
            comboBoxGrade.Items.Add("2 - Fail");
            comboBoxGrade.Items.Add("3");
            comboBoxGrade.Items.Add("4");
            comboBoxGrade.Items.Add("5");
            comboBoxGrade.Items.Add("6");
            comboBoxGrade.SelectedIndex = 0;
        }

        private void ButtonSave_Click(object? sender, EventArgs e)
        {
            if (comboBoxStudent.SelectedValue == null || comboBoxSubject.SelectedValue == null || comboBoxGrade.SelectedItem == null)
            {
                MessageBox.Show("Please select student, subject, and grade.");
                return;
            }

            int studentId = Convert.ToInt32(comboBoxStudent.SelectedValue);
            int subjectId = Convert.ToInt32(comboBoxSubject.SelectedValue);
            int grade = int.Parse(comboBoxGrade.SelectedItem.ToString()!.Split(' ')[0]);
            DateTime gradeDate = dateTimePicker1.Value;

            try
            {
                using (var conn = new OracleConnection(connectionString))
                {
                    conn.Open();

                    string insertQuery = @"
                INSERT INTO OCENKI (GRADEID, STUDENTID, SUBJECTID, LECTURERID, GRADE, GRADE_DATE)
                VALUES (OCENKI_SEQ.NEXTVAL, :studentId, :subjectId, :lecturerId, :grade, :gradeDate)";

                    using (OracleCommand cmd = new OracleCommand(insertQuery, conn))
                    {
                        cmd.Parameters.Add("studentId", studentId);
                        cmd.Parameters.Add("subjectId", subjectId);
                        cmd.Parameters.Add("lecturerId", _lecturerId);
                        cmd.Parameters.Add("grade", grade);
                        cmd.Parameters.Add("gradeDate", gradeDate);

                        cmd.ExecuteNonQuery();
                    }

                    MessageBox.Show("Grade saved successfully!");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error saving grade: " + ex.Message);
            }
        }

    }
}
