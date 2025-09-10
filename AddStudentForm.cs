using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class AddStudentForm : Form
    {
        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        // Form controls
        private TextBox txtFirstName = new TextBox();
        private TextBox txtLastName = new TextBox();
        private TextBox txtFacnom = new TextBox();
        private ComboBox cmbForm = new ComboBox();
        private ComboBox cmbOKS = new ComboBox();
        private TextBox txtPriem = new TextBox();
        private ComboBox cmbFakultet = new ComboBox();
        private ComboBox cmbSpecialty = new ComboBox();
        private ComboBox cmbGroup = new ComboBox();
        private TextBox txtSemCount = new TextBox();
        private TextBox txtKurs = new TextBox();
        private Button btnAddStudent = new Button();

        public AddStudentForm()
        {
            InitializeComponent();
            SetupUI();
            SetupFormAndOKS();
            LoadFaculties();

            // Event handlers
            txtFacnom.TextChanged += TxtFacnom_TextChanged;
            cmbFakultet.SelectedIndexChanged += CmbFakultet_SelectedIndexChanged;
            cmbSpecialty.SelectedIndexChanged += CmbSpecialty_SelectedIndexChanged;
            btnAddStudent.Click += BtnAddStudent_Click;
        }

        private void SetupUI()
        {
            this.Text = "Add Student";
            this.Size = new Size(500, 600);
            this.StartPosition = FormStartPosition.CenterScreen;

            int labelX = 30, controlX = 150, top = 30, gap = 35;

            void AddLabelAndControl(string labelText, Control control)
            {
                Label lbl = new Label
                {
                    Text = labelText,
                    Location = new Point(labelX, top),
                    AutoSize = true
                };
                control.Location = new Point(controlX, top - 3);
                this.Controls.Add(lbl);
                this.Controls.Add(control);
                top += gap;
            }

            AddLabelAndControl("First Name:", txtFirstName);
            AddLabelAndControl("Last Name:", txtLastName);
            AddLabelAndControl("FacNom:", txtFacnom);
            AddLabelAndControl("Form:", cmbForm);
            AddLabelAndControl("OKS:", cmbOKS);
            AddLabelAndControl("Priem:", txtPriem);
            AddLabelAndControl("Faculty:", cmbFakultet);
            AddLabelAndControl("Specialty:", cmbSpecialty);
            AddLabelAndControl("Group:", cmbGroup);
            AddLabelAndControl("Semester Count:", txtSemCount);
            AddLabelAndControl("Course:", txtKurs);

            btnAddStudent.Text = "Add Student";
            btnAddStudent.Location = new Point(controlX, top);
            this.Controls.Add(btnAddStudent);
        }

        private void LoadFaculties()
        {
            try
            {
                using OracleConnection conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT fakultetid, fullname FROM fakulteti ORDER BY fullname";
                using OracleCommand cmd = new OracleCommand(sql, conn);
                using OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                cmbFakultet.DataSource = dt;
                cmbFakultet.DisplayMember = "fullname";
                cmbFakultet.ValueMember = "fakultetid";
                cmbFakultet.SelectedIndex = -1;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading faculties: " + ex.Message);
            }
        }

        private void CmbFakultet_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cmbFakultet.SelectedValue == null)
                return;

            int fakultetId = (cmbFakultet.SelectedValue is DataRowView drv)
                ? Convert.ToInt32(drv["fakultetid"])
                : Convert.ToInt32(cmbFakultet.SelectedValue);

            LoadSpecialties(fakultetId);
        }

        private void LoadSpecialties(int fakultetId)
        {
            try
            {
                using OracleConnection conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT specid, name FROM specialnosti WHERE fakultetid = :fid ORDER BY name";
                using OracleCommand cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("fid", fakultetId);
                using OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                cmbSpecialty.DataSource = dt;
                cmbSpecialty.DisplayMember = "name";
                cmbSpecialty.ValueMember = "specid";
                cmbSpecialty.SelectedIndex = -1;

                cmbGroup.DataSource = null; // clear group combobox
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading specialties: " + ex.Message);
            }
        }

        private void CmbSpecialty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cmbSpecialty.SelectedValue == null)
                return;

            int specId = (cmbSpecialty.SelectedValue is DataRowView drv)
                ? Convert.ToInt32(drv["specid"])
                : Convert.ToInt32(cmbSpecialty.SelectedValue);

            LoadGroups(specId);
        }
        private void SetupFormAndOKS()
        {
            // Form (Form of education)
            cmbForm.Items.Clear();
            cmbForm.Items.AddRange(new string[] { "Full-time", "Part-time"});
            cmbForm.SelectedIndex = -1;

            // OKS (Educational qualification)
            cmbOKS.Items.Clear();
            cmbOKS.Items.AddRange(new string[] { "Bachelor", "Master", "PhD" });
            cmbOKS.SelectedIndex = -1;
        }

        private void LoadGroups(int specId)
        {
            try
            {
                using OracleConnection conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT groupid, name FROM grupi WHERE specid = :sid ORDER BY name";
                using OracleCommand cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("sid", specId);
                using OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                cmbGroup.DataSource = dt;
                cmbGroup.DisplayMember = "name";
                cmbGroup.ValueMember = "groupid";
                cmbGroup.SelectedIndex = -1;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading groups: " + ex.Message);
            }
        }

        private void TxtFacnom_TextChanged(object? sender, EventArgs e)
        {
            if (txtFacnom.Text.Length < 3) // check for at least 3 characters
                return;

            char thirdChar = txtFacnom.Text[2]; // third character is index 2
            if (!int.TryParse(thirdChar.ToString(), out int facultyDigit))
                return;

            int? facultyId = facultyDigit switch
            {
                1 => GetFacultyIdByShortName("MFT"),
                3 => GetFacultyIdByShortName("KF"),
                4 => GetFacultyIdByShortName("EF"),
                6 => GetFacultyIdByShortName("FITA"),
                7 => GetFacultyIdByShortName("DTK"),
                9 => GetFacultyIdByShortName("KTU"),
                10 => GetFacultyIdByShortName("DEPOS"),
                2 => GetFacultyIdByShortName("ETE"),
                _ => null
            };

            if (facultyId.HasValue)
                cmbFakultet.SelectedValue = facultyId.Value;
        }


        private int? GetFacultyIdByShortName(string shortName)
        {
            try
            {
                using OracleConnection conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT fakultetid FROM fakulteti WHERE shortname = :sn";
                using OracleCommand cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("sn", shortName);
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : null;
            }
            catch
            {
                return null;
            }
        }

        private void BtnAddStudent_Click(object? sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtFirstName.Text) || string.IsNullOrWhiteSpace(txtLastName.Text)
                || string.IsNullOrWhiteSpace(txtFacnom.Text) || cmbFakultet.SelectedIndex == -1
                || cmbSpecialty.SelectedIndex == -1 || cmbGroup.SelectedIndex == -1)
            {
                MessageBox.Show("Please fill all required fields.");
                return;
            }

            try
            {
                using OracleConnection conn = new OracleConnection(connectionString);
                conn.Open();

                string sql = @"
                    INSERT INTO students(studentid, firstname, lastname, facnom, form_na_obuchenie, oks, priem, fakultetid, specid, groupid, semesturcount, kurs)
                    VALUES(students_seq.NEXTVAL, :firstname, :lastname, :facnom, :form, :oks, :priem, :fid, :sid, :gid, :sem, :kurs)";

                using OracleCommand cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("firstname", txtFirstName.Text);
                cmd.Parameters.Add("lastname", txtLastName.Text);
                cmd.Parameters.Add("facnom", txtFacnom.Text);
                cmd.Parameters.Add("form", cmbForm.Text);
                cmd.Parameters.Add("oks", cmbOKS.Text);
                cmd.Parameters.Add("priem", Convert.ToInt32(txtPriem.Text));
                cmd.Parameters.Add("fid", Convert.ToInt32(cmbFakultet.SelectedValue));
                cmd.Parameters.Add("sid", Convert.ToInt32(cmbSpecialty.SelectedValue));
                cmd.Parameters.Add("gid", Convert.ToInt32(cmbGroup.SelectedValue));
                cmd.Parameters.Add("sem", Convert.ToInt32(txtSemCount.Text));
                cmd.Parameters.Add("kurs", Convert.ToInt32(txtKurs.Text));

                int rowsInserted = cmd.ExecuteNonQuery();
                if (rowsInserted > 0)
                {
                    MessageBox.Show("Student added successfully!");
                    ClearForm();
                }
                else
                {
                    MessageBox.Show("Failed to add student.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error adding student: " + ex.Message);
            }
        }

        private void ClearForm()
        {
            txtFirstName.Clear();
            txtLastName.Clear();
            txtFacnom.Clear();
            cmbForm.SelectedIndex = -1;
            cmbOKS.SelectedIndex = -1;
            txtPriem.Clear();
            cmbFakultet.SelectedIndex = -1;
            cmbSpecialty.DataSource = null;
            cmbGroup.DataSource = null;
            txtSemCount.Clear();
            txtKurs.Clear();
        }
    }
}
