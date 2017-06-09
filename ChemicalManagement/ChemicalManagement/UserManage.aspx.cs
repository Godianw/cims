using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChemicalManagement
{
    public partial class UserManage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UsersGV_BindData();
        }

        protected void UsersGV_BindData()
        {
            CIMSDBEntities db = new CIMSDBEntities();

            string adminName = "admin";
            /* 查询整个表 */
            List<Users> usersModel = db.Users.Where(m => m.user_id != 0 && m.user_name != adminName).ToList();
            users_GridView.DataSource = usersModel;
            users_GridView.DataBind();
        }

        protected void users_GridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            CIMSDBEntities db = new CIMSDBEntities();

            /* 删除数据 */
            string _id = users_GridView.Rows[e.RowIndex].Cells[0].Text;
            Users delRecoed = new Users() { user_id = Convert.ToInt32(_id) };
            db.Users.Attach(delRecoed);
            db.Users.Remove(delRecoed);
            db.SaveChanges();

            // 刷新表
            UsersGV_BindData();
        }

        // 按下确定按钮添加新用户
        protected void okBtn_Click(object sender, EventArgs e)
        {
            string username = newUsersPhone.Value;
            string password = newUsersPassword.Value;

            CIMSDBEntities db = new CIMSDBEntities();
            Users newUser = new Users()
            {
                user_name = username,
                user_password = password,
                user_group_id = 1
            };

            db.Users.Add(newUser);

            try
            {
                db.SaveChanges();
            }
            catch (Exception)
            {
                ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('添加用户时发生未知错误');</script>");
                return;
            }

            // 刷新表
            UsersGV_BindData();
        }
    }
}