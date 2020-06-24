<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>聊天记录</title>
    <link rel="stylesheet" href="/static/lib/layui/css/layui.css">
    <style>
        body .layim-chat-main {
            height: auto;
        }
        #LAY_page {
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="layim-chat-main">
    <ul id="LAY_view"></ul>
</div>

<div id="LAY_page" data-count="{{ pager.total_items }}"></div>

<textarea title="消息模版" id="LAY_tpl" style="display:none;">
<%# layui.each(d.data, function(index, item) {
  if (item.user.id == parent.layui.layim.cache().mine.id) { %>
    <li class="layim-chat-mine"><div class="layim-chat-user"><img src="<% item.user.avatar %>"><cite><i><% layui.data.date(item.timestamp) %></i><% item.user.name %></cite></div><div class="layim-chat-text"><% layui.layim.content(item.content) %></div></li>
  <%# } else { %>
    <li><div class="layim-chat-user"><img src="<% item.user.avatar %>"><cite><% item.user.name %><i><% layui.data.date(item.timestamp) %></i></cite></div><div class="layim-chat-text"><% layui.layim.content(item.content) %></div></li>
  <%# }
}); %>
</textarea>

<script src="/static/lib/layui/layui.js"></script>

<script>
    layui.use(['jquery', 'layim', 'laytpl', 'laypage'], function () {

        var $ = layui.jquery;
        var layim = layui.layim;
        var laytpl = layui.laytpl;
        var laypage = layui.laypage;

        laytpl.config({
            open: '<%',
            close: '%>'
        });

        var $target = $('#LAY_view');
        var $page = $('#LAY_page');
        var $tpl = $('#LAY_tpl');

        var count = $page.data('count');
        var limit = 15;

        var params = {
            id: layui.url().search.id,
            type: layui.url().search.type,
            limit: limit,
            sort: 'oldest',
            page: 1
        };

        /**
         * 加载第一页数据
         */
        loadPageHtml($target, params);

        /**
         * 两页以上才显示分页
         */
        if (count > limit) {
            laypage.render({
                elem: $page.attr('id'),
                limit: limit,
                count: count,
                layout: ['page', 'count'],
                jump: function (obj, first) {
                    if (!first) {
                        params.page = obj.curr;
                        loadPageHtml($target, params);
                    }
                }
            });
        }

        function loadPageHtml(target, params) {
            $.get('/im/chat/history', params, function (res) {
                var html = laytpl($tpl.val()).render({
                    data: res.items
                });
                target.html(html);
            });
        }

    });
</script>

</body>
</html>
