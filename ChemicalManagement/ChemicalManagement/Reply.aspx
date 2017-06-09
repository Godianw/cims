<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Reply.aspx.cs" Inherits="ChemicalManagement.Reply" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPH1" runat="server">

    <br /><br />

    <div class="conrainer page-header">
        <div class="row">
            <!-- 材料名称 -->
            <div class="col-xs-10 col-xs-push-1 col-sm-10 col-sm-push-1 col-md-10 col-md-push-1 ">
                <h2>留言回复
                    <small>Message Reply</small>
                </h2>
            </div>
        </div>
    </div>
    
    <br />

    <div class="container">
        <div id="replyDialog" class="modal fade" data-backdrop="static" tabindex="-1" 
            role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                        <h4 class="modal-title" id="myModalLabel">
                            回复
                        </h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label id="replyLabel">回复：</label>
                            <textarea class="form-control input-sm" rows="5" maxlength="100"
                                style="resize:none" placeholder="不超过100个字" 
                                runat="server" id="replyTextArea"></textarea>
                        </div>
                        <div class="form-group"> 
                            <asp:Button CssClass="btn btn-warning" ID="replyBtn" runat="server"
                                OnClick="replyBtn_Click" Text="回复"></asp:Button>
                            <input id="id_lab" type="hidden" runat="server" />
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <asp:GridView ID="msg_GridView" runat="server" AutoGenerateColumns="False" GridLines="None"
            AllowPaging="True" CssClass="mGrid" PagerStyle-CssClass="pgr" 
            AlternatingRowStyle-CssClass="alt" DataKeyNames="msg_id" 
            ShowHeaderWhenEmpty="True" EmptyDataText="找不到相关记录"
            OnRowDeleting="msg_GridView_RowDeleting">    
            <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
            <Columns>
                <asp:BoundField DataField="msg_id" HeaderText="留言id" InsertVisible="False" 
                    ReadOnly="True" SortExpression="msg_id" />
                <asp:BoundField DataField="user_name" HeaderText="用户名"
                    ReadOnly="true" SortExpression="user_name" />
                <asp:BoundField DataField="msg_content" HeaderText="留言内容" 
                    ReadOnly="true" SortExpression="msg_content" />
                <asp:BoundField DataField="msg_time" HeaderText="留言时间" 
                    ReadOnly="true" SortExpression="msg_time" />
                <asp:BoundField DataField="reply_content" HeaderText="回复内容" 
                    SortExpression="reply_content" />
                <asp:BoundField DataField="reply_time" HeaderText="回复时间" 
                    ReadOnly="true" SortExpression="reply_time" />


                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <a data-toggle="modal" href="#replyDialog" onclick="select()"> 回复</a>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ShowDeleteButton="True"
                    DeleteText="<div onclick=&quot;JavaScript:return confirm('用户记录删除后将无法恢复，确认要删除吗?')&quot;>删除<div/>" />
            
            </Columns>

            <PagerStyle CssClass="pgr"></PagerStyle>
        </asp:GridView>
    </div>

    <script type="text/javascript">

        function onload2() {

        }

        function select() {

            

            //获取鼠标点击的元素
            var e = event.srcElement;
            //获取元素所在的行的行号（表头行号从0开始）。注意：parentElement只适用于IE浏览器，而parentNode则符合DOM标准。
            //var rowIndex=e.parentElement.parentElement.rowIndex ;
       //     var rowIndex = e.parentNode.parentNode.rowIndex;
            var curRow = e.parentNode.parentNode;
            
            //获取label控件
            var label = document.getElementById("replyLabel");
            //分别获取选定行指定列的值
            label.innerHTML = "回复：<Label style=\"color:gray\">\"" + curRow.cells[1].innerHTML + ":"
                + curRow.cells[2].innerHTML + "\"</Label>";
            document.getElementById('<%=id_lab.ClientID %>').value = curRow.cells[0].innerHTML;
            
      //     

            return true;
        }
    </script>

</asp:Content>
