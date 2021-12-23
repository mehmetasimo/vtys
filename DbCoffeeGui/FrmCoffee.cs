using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using Npgsql;

namespace DbCoffeeGui
{
    public partial class FrmCoffee : Form
    {
        public FrmCoffee()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=DBCoffee; user Id = postgres; password=*******");
        private void btnList_Click(object sender, EventArgs e)
        {
            string sorgu = "select * from \"Coffee\"";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {

        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut1 = new NpgsqlCommand("insert into \"Coffee\" (\"CoffeeID\", \"CoffeeName\", \"HarvestingYear\", \"Importer\", \"Price\", " +
                "\"Variety\", \"Process\",\"CountryID\",\"BrewID\",\"RoastedID\") values " +
                "(@p1,@p2,@p3,@p4,@p5,@p6,@p7,@p8,@p9,@p10)", baglanti);
            komut1.Parameters.AddWithValue("@p1", int.Parse(txtCoffeeID.Text));
            komut1.Parameters.AddWithValue("@p2", txtName.Text);
            komut1.Parameters.AddWithValue("@p3", int.Parse(txtYear.Text));
            komut1.Parameters.AddWithValue("@p4", txtImporter.Text);        
            komut1.Parameters.AddWithValue("@p5", int.Parse(txtPrice.Text));
            komut1.Parameters.AddWithValue("@p6", txtVariety.Text);
            komut1.Parameters.AddWithValue("@p7", txtProcess.Text);
            komut1.Parameters.AddWithValue("@p8", int.Parse(txtCountryCode.Text));
            komut1.Parameters.AddWithValue("@p9", int.Parse(txtBrewedID.Text));
            komut1.Parameters.AddWithValue("@p10", int.Parse(txtRoastedID.Text));
 
            komut1.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Kahve ekleme işlemi tamamlandı","bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);


        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut2 = new NpgsqlCommand("delete from \"Coffee\" where \"CoffeeID\"=@p1", baglanti);
            komut2.Parameters.AddWithValue("@p1", int.Parse(txtCoffeeID.Text));
            komut2.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Kahve silme işlemini onaylıyor musunuz?", "Bilgi", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            MessageBox.Show("Kahve silme işlemi tamamlandı","bilgi",MessageBoxButtons.OK,MessageBoxIcon.Stop);

        }

        private void pictureBox4_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut3 = new NpgsqlCommand("Update \"Coffee\" set \"CoffeeName\"=@p2,\"HarvestingYear\"=@p3,\"Importer\"=@p4,\"Price\"=@p5,\"Variety\"=@p6,\"Process\"=@p7"+
                "  where \"CoffeeID\" = @p1", baglanti);

            komut3.Parameters.AddWithValue("@p1", int.Parse(txtCoffeeID.Text));
            komut3.Parameters.AddWithValue("@p2", txtName.Text);
            komut3.Parameters.AddWithValue("@p3", int.Parse(txtYear.Text));
            komut3.Parameters.AddWithValue("@p4", txtImporter.Text);
            komut3.Parameters.AddWithValue("@p5", int.Parse(txtPrice.Text));
            komut3.Parameters.AddWithValue("@p6", txtVariety.Text);
            komut3.Parameters.AddWithValue("@p7", txtProcess.Text);
            /* komut3.Parameters.AddWithValue("@p8", int.Parse(txtCountryCode.Text));
            komut3.Parameters.AddWithValue("@p9", int.Parse(txtBrewedID.Text));
            komut3.Parameters.AddWithValue("@p10", int.Parse(txtRoastedID.Text));
            \"CountryID\"=@p8,\"BrewID\"=@p9,\"RoastedID\"=@p10
             */
            komut3.ExecuteNonQuery();
            MessageBox.Show("Kahve güncelleme işlemi tamamlandı", "bilgi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }


        private void txtCoffeeID_TextChanged(object sender, EventArgs e)
        {

        }

        private void txtImporter_TextChanged(object sender, EventArgs e)
        {

        }

        private void txtCountryCode_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            string sorgu = "select * from public.\"Coffee\" where \"CoffeeName\" LIKE '%" + txtName.Text + "%'";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
            baglanti.Close();
        }
    }
}
