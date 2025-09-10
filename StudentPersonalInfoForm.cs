using System;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class StudentPersonalInfoForm : Form
    {
        private TextBox txtFirstname = new TextBox();
        private TextBox txtLastname = new TextBox();
        private TextBox txtFaknom = new TextBox();
        private TextBox txtForma = new TextBox();
        private TextBox txtOks = new TextBox();
        private TextBox txtPriem = new TextBox();
        private TextBox txtFakultet = new TextBox();
        private TextBox txtSpec = new TextBox();
        private TextBox txtGroup = new TextBox(); // New field for group name
        private TextBox txtSemester = new TextBox();
        private TextBox txtKurs = new TextBox();
        private TextBox txtEduType = new TextBox();
        private TextBox txtStatus = new TextBox();
        private Button btnClose = new Button();

        private readonly int studentId;
        private readonly string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        public StudentPersonalInfoForm(int studentId)
        {
            this.studentId = studentId;

            InitializeComponent();
            SetupCustomUI();
            LoadStudentData();
        }

        private void SetupCustomUI()
        {
            this.Text = "Student Personal Information";
            this.Size = new Size(500, 600); // Increased height to fit new field
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = Color.White;

            int startY = 20;
            int spacing = 40;
            int textBoxWidth = 250;

            void AddField(string labelText, TextBox txt, int y)
            {
                Label lbl = new Label
                {
                    Text = labelText,
                    Location = new Point(20, y),
                    AutoSize = true,
                    Font = new Font("Segoe UI", 9F, FontStyle.Bold)
                };
                txt.Location = new Point(180, y - 3);
                txt.Width = textBoxWidth;
                txt.ReadOnly = true;

                this.Controls.Add(lbl);
                this.Controls.Add(txt);
            }

            AddField("Firstname:", txtFirstname, startY);
            AddField("Lastname:", txtLastname, startY + spacing);
            AddField("Faknom:", txtFaknom, startY + spacing * 2);
            AddField("Form of Study:", txtForma, startY + spacing * 3);
            AddField("OKS:", txtOks, startY + spacing * 4);
            AddField("Priem:", txtPriem, startY + spacing * 5);
            AddField("Faculty:", txtFakultet, startY + spacing * 6);
            AddField("Specialty:", txtSpec, startY + spacing * 7);
            AddField("Group:", txtGroup, startY + spacing * 8); // New field
            AddField("Semester:", txtSemester, startY + spacing * 9);
            AddField("Kurs:", txtKurs, startY + spacing * 10);
            AddField("Education Type:", txtEduType, startY + spacing * 11);
            AddField("Status:", txtStatus, startY + spacing * 12);

            btnClose.Text = "Close";
            btnClose.Size = new Size(100, 30);
            btnClose.Location = new Point((this.ClientSize.Width - btnClose.Width) / 2, startY + spacing * 13);
            btnClose.BackColor = Color.SteelBlue;
            btnClose.ForeColor = Color.White;
            btnClose.FlatStyle = FlatStyle.Flat;
            btnClose.Click += (s, e) => this.Close();
            this.Controls.Add(btnClose);
        }

        private void LoadStudentData()
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string query = @"
                    SELECT s.firstname, s.lastname, s.facnom, s.form_na_obuchenie, s.oks, s.priem,
                           f.fullname AS fakultet_name,
                           sp.name AS spec_name,
                           g.name AS group_name,
                           s.semesturcount AS semester, s.kurs,
                           e.education_type_name, s.status
                    FROM students s
                    LEFT JOIN fakulteti f ON s.fakultetid = f.fakultetid
                    LEFT JOIN specialnosti sp ON s.specid = sp.specid
                    LEFT JOIN grupi g ON s.groupid = g.groupid
                    LEFT JOIN education_types e ON s.education_type_id = e.education_type_id
                    WHERE s.studentid = :studentId";

                using var cmd = new OracleCommand(query, conn);
                cmd.Parameters.Add("studentId", OracleDbType.Int32).Value = studentId;

                using var reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtFirstname.Text = reader["firstname"].ToString();
                    txtLastname.Text = reader["lastname"].ToString();
                    txtFaknom.Text = reader["facnom"].ToString();
                    txtForma.Text = reader["form_na_obuchenie"].ToString();
                    txtOks.Text = reader["oks"].ToString();
                    txtPriem.Text = reader["priem"].ToString();
                    txtFakultet.Text = reader["fakultet_name"].ToString();
                    txtSpec.Text = reader["spec_name"].ToString();
                    txtGroup.Text = reader["group_name"].ToString(); // Set group name
                    txtSemester.Text = reader["semester"].ToString();
                    txtKurs.Text = reader["kurs"].ToString();
                    txtEduType.Text = reader["education_type_name"].ToString();
                    txtStatus.Text = reader["status"].ToString();
                }
                else
                {
                    MessageBox.Show("Student data not found.");
                    this.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading student data: " + ex.Message);
            }
        }
    }
}
