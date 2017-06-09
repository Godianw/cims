<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="UserManage.aspx.cs" Inherits="ChemicalManagement.UserManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPH1" runat="server">
    
    <br /><br />

    <div class="conrainer page-header">
        <div class="row">
            <!-- 材料名称 -->
            <div class="col-xs-10 col-xs-push-1 col-sm-10 col-sm-push-1 col-md-10 col-md-push-1 ">
                <h2>账户管理
                    <small>Users Management</small>
                </h2>
            </div>
        </div>
    </div>
    
    <br />

    <!-- 添加新用户对话框 -->
    <div id="newUsersDialog" class="modal fade" data-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">添加新用户
                    </h4>
                </div>

                <div class="modal-body row">
                    <div class="form-horizontal">
                        <div class="form-group">
                            <input type="text" class="form-control" id="newUsersPhone"
                                placeholder="手机号" runat="server"/>
                            <i class="icon-user"></i>
                        </div>

                        <div class="form-group">
                            <input type="password" class="form-control" id="newUsersPassword"
                                placeholder="密码，至少为6位数字或字母" runat="server" />
                            <i class="icon-lock"></i>
                        </div>

                        <div class="form-group">
                            <asp:Button ID="okBtn" CssClass="btn btn-primary" runat="server" 
                                OnClick="okBtn_Click" Text="确定"></asp:Button>
                            <button class="btn btn-danger" data-dismiss="modal">取消</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- 添加用户按钮 -->
    <div class ="row">
        <div class="col-xs-3 col-xs-push-1 col-sm-3 col-sm-push-1 col-md-2 col-md-push-1">
            <a data-toggle="modal" href="#newUsersDialog" class="btn btn-primary button-glow">
                <span class="glyphicon glyphicon-plus"></span>添加用户
            </a>
        </div>
    </div>

    <br /><br />

    <div class="container">
        <asp:GridView ID="users_GridView" runat="server" AutoGenerateColumns="False" GridLines="None"
            AllowPaging="True" CssClass="mGrid" PagerStyle-CssClass="pgr" 
            AlternatingRowStyle-CssClass="alt" DataKeyNames="user_id" 
            ShowHeaderWhenEmpty="True" EmptyDataText="找不到相关记录"
            OnRowDeleting="users_GridView_RowDeleting">    
            <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
            <Columns>
                <asp:BoundField DataField="user_id" HeaderText="用户id" InsertVisible="False" 
                    ReadOnly="True" SortExpression="user_id" />
                <asp:BoundField DataField="user_name" HeaderText="用户名"
                    ReadOnly="true" SortExpression="user_name" />
                <asp:BoundField DataField="user_password" HeaderText="用户密码" 
                    SortExpression="user_password" />
                
                <asp:CommandField HeaderText="删除" ShowDeleteButton="True"
                    DeleteText="<div onclick=&quot;JavaScript:return confirm('用户记录删除后将无法恢复，确认要删除吗?')&quot;>删除该用户<div/>" />
            
            </Columns>

            <PagerStyle CssClass="pgr"></PagerStyle>
        </asp:GridView>    
    </div>

    <link type="text/css" rel="stylesheet" href="css/buttons.css"/>

</asp:Content>
