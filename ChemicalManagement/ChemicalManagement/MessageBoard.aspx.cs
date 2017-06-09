using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChemicalManagement
{
    public partial class MessageBoard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            FlashMessageBoard();
        }

        protected void FlashMessageBoard()
        {
            messageBoard.InnerHtml = "";

            int user_id = 0;
            string username = null;
            CIMSDBEntities db = new CIMSDBEntities();
            if (Session["username"] != null)
            {
                username = Session["username"].ToString();
                user_id = db.Users.Where(p => p.user_name == username)
                    .Select(s => s.user_id).First();
            }

            if (user_id == 0)
                return;
            
            var records = db.Message.Where(p => p.msg_user_id == user_id);
            foreach (var singleRecord in records)
            {
      //          int user_id = singleRecord.msg_user_id;
      //          string username = db.Users.Where(p => p.user_id == user_id).Select(s => s.user_name).First().ToString();
                string content = singleRecord.msg_content;
                string time = "20" + singleRecord.msg_time;
                addNewUsersMsg(username, content, time);

                string reply = singleRecord.reply_content;
                if (reply != null)
                {
                    string replyTime = singleRecord.reply_time;
                    addAdminReply(reply, replyTime);
                }
            }
        }

        protected void addNewUsersMsg(string username, string msg, string time)
        {
            messageBoard.InnerHtml += "<li class=\"list-group-item\"><div class=\"media\">";
            messageBoard.InnerHtml += "<a class=\"pull-left\">";
            messageBoard.InnerHtml += "<img class=\"media-object\" src=\"img/userIcon.jpg\" alt=\"users\" width=\"100\" height=\"100\" /></a>";
            messageBoard.InnerHtml += "<div class=\"media-body\"> <h4 class=\"media-heading\">";
            messageBoard.InnerHtml += username + "</h4>" + msg + "</div></div></li>";

            messageBoard.InnerHtml += "<li class=\"list-group-item text-left\">发表于" + time + "</li>";
        }

        protected void addAdminReply(string reply, string time)
        {
            messageBoard.InnerHtml += "<li class=\"list-group-item\"><div class=\"media\">";
            messageBoard.InnerHtml += "<a class=\"pull-right\">";
            messageBoard.InnerHtml += "<img class=\"media-object\" src=\"img/admin.jpg\" alt=\"admin\" width=\"100\" height=\"100\" /></a>";
            messageBoard.InnerHtml += "<div class=\"media-body text-right\" > <h4 class=\"media-heading\">";
            messageBoard.InnerHtml += "管理员回复</h4>" + reply + "</div></div></li>";

            messageBoard.InnerHtml += "<li class=\"list-group-item text-right\">回复于" + time + "</li>";
        }

    /*    protected void addReplyBtn()
        {
            messageBoard.InnerHtml += "<li class=\"list-group-item\"><div class=\"media\">";
            messageBoard.InnerHtml += "<a class=\"pull-right\" href=\"#\">回复</a>";
            messageBoard.InnerHtml += "</div></li>";
        }*/

        protected void msgBtn_Click(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('请先登录后再进行留言');</script>");
                return;
            }

            CIMSDBEntities db = new CIMSDBEntities();
            string username = Session["username"].ToString();

            int userId = db.Users.Where(p => p.user_name == username).Select(s => s.user_id).First();
            string content = msgTextArea.Value;
            string time = DateTime.Now.ToString("yyyy/MM/dd HH:mm").Substring(2);

            if (content == "")
            {
                ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('您输入的内容为空');</script>");
                return;
            }

            Message newMsg = new Message()
            {
                msg_user_id = userId,
                msg_content = content,
                msg_time = time
            };

            db.Message.Add(newMsg);
            try
            {
                db.SaveChanges();
            }
            catch (Exception)
            {
                ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('留言失败，请重试');</script>");
            }

            Page_Load(sender, e);
        }
    }
}