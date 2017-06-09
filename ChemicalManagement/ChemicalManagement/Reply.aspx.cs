using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChemicalManagement
{
    public partial class Reply : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            MsgGV_BindData();
        }

        protected void MsgGV_BindData()
        {
            CIMSDBEntities db = new CIMSDBEntities();

            /* 查询整个表 */
            List<View_Msg> msgModel = db.View_Msg.Where(m => m.msg_id != 0).ToList();
            msg_GridView.DataSource = msgModel;
            msg_GridView.DataBind();
        }

        protected void msg_GridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            /* 删除数据 */
            string _id = msg_GridView.Rows[e.RowIndex].Cells[0].Text;
            Message delRecoed = new Message() { msg_id = Convert.ToInt32(_id) };
            CIMSDBEntities db = new CIMSDBEntities();
            db.Message.Attach(delRecoed);
            db.Message.Remove(delRecoed);
            db.SaveChanges();

            // 刷新表
            MsgGV_BindData();
        }

        protected void replyBtn_Click(object sender, EventArgs e)
        {
            string id = id_lab.Value;
            if (id == null)
                return;

            string reply_content = replyTextArea.Value;
            if (reply_content == null)
            {
                ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('您输入的内容为空');</script>");
            }

            string reply_time = DateTime.Now.ToString("yyyy/MM/dd HH:mm").Substring(2);

            CIMSDBEntities db = new CIMSDBEntities();

            try
            {
                int int_Id = Convert.ToInt32(id);
                var record = db.Message.First(r => r.msg_id == int_Id);
                record.reply_content = reply_content;
                record.reply_time = reply_time;

                db.SaveChanges();
            }
            catch(Exception)
            {
                ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('回复失败');</script>");
            }

            Page_Load(sender, e);
        }
    }
}