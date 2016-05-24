(function ($) {
    $.fn.EasyTree = function (options) {
        var defaults = {
            i18n: {
                deleteNull: 'Please select the node to delete。',
                deleteConfirmation: 'Are you sure？',
                confirmButtonLabel: 'Confirm',
                editNull: 'Please select the node to edit',
                editMultiple: 'Not support multiple edit',
                addMultiple: 'Please select the node to add',
                addNull: 'Please select the node to add',
                collapseTip: 'Collapse branch',
                expandTip: 'Expend branch',
                selectTip: 'Select',
                unselectTip: 'Cancel selection',
                editTip: 'Edit',
                addTip: 'Add',
                deleteTip: 'Remove',
                cancelButtonLabel: 'Cancel'
            }
        };

        var warningAlert = $('<div class="alert alert-warning alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><strong></strong><span class="alert-content"></span> </div> ');
        var dangerAlert = $('<div class="alert alert-danger alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><strong></strong><span class="alert-content"></span> </div> ');

        var createInput = $('.input-group');

        options = $.extend(defaults, options);

        this.each(function () {
            var easyTree = $(this);
            var toolbar = $('.easy-tree-toolbar');
            var createInput = $('.input-group');
            $.each($(easyTree).find('ul > li'), function () {
                var text;
                if ($(this).is('li:has(ul)')) {
                    var children = $(this).find(' > ul');
                    $(children).remove();
                    text = $(this).text().replace(/[\n]/g, "");
                    $(this).html('<span><span class="glyphicon"></span><a href="javascript: void(0);"></a> </span>');
                    $(this).find(' > span > span').addClass('glyphicon-folder-open');
                    $(this).find(' > span > a').text(text);
                    $(this).append(children);
                }
                else {
                    text = $(this).text().replace(/[\n]/g, "");
                    $(this).html('<span><span class="glyphicon"></span><a href="javascript: void(0);"></a> </span>');
                    $(this).find(' > span > span').addClass('glyphicon-file');
                    $(this).find(' > span > a').text(text);
                }
            });

            $(easyTree).find('li:has(ul)').addClass('parent_li').find(' > span').attr('title', options.i18n.collapseTip);

            // addable
            $(toolbar).find('.create > button').attr('title', options.i18n.addTip).click(function () {

                var selected = getSelectedItems();
                if (selected.length <= 0) {
                    $(toolbar).prepend(warningAlert);
                    $(toolbar).find('.alert .alert-content').html(options.i18n.addNull);
                } else if (selected.length > 1) {
                    $(toolbar).prepend(warningAlert);
                    $(toolbar).find('.alert .alert-content').text(options.i18n.addMultiple);
                } else {

                    $(createInput).find('input').removeAttr("disabled");
                    $(createInput).find('input').focus();
                    $(createInput).find('button').removeClass('disabled');
                    $(createInput).find('.confirm').click(function () {

                        if ($(createInput).find('input').val() === '')
                            return;
                        var selected = getSelectedItems();
                        var item = $('<li><span><span class="glyphicon glyphicon-file"></span><a href="javascript: void(0);">' + $(createInput).find('input').val() + '</a> </span></li>');

                        $(item).find(' > span > span').attr('title', options.i18n.collapseTip);
                        $(item).find(' > span > a').attr('title', options.i18n.selectTip);

                        if ($(selected).hasClass('parent_li')) {
                            $(selected).find(' > ul').append(item);
                        } else {
                            $(selected).addClass('parent_li').find(' > span > span').addClass('glyphicon-folder-open').removeClass('glyphicon-file');
                            $(selected).append($('<ul></ul>')).find(' > ul').append(item);
                        }

                        $(createInput).find('input').val('');
                        $(item).find(' > span > a').attr('title', options.i18n.selectTip);

                        $(item).find(' > span > a').click(function (e) {
                            var li = $(this).parent().parent();
                            if (li.hasClass('li_selected')) {
                                $(this).attr('title', options.i18n.selectTip);
                                $(li).removeClass('li_selected');
                            }
                            else {
                                $(easyTree).find('li.li_selected').removeClass('li_selected');
                                $(this).attr('title', options.i18n.unselectTip);
                                $(li).addClass('li_selected');
                            }

                            e.stopPropagation();

                        });

                        $(createInput).find('input').attr("disabled", true);
                        $(createInput).find('button').addClass('disabled');
                    });

                }

            });

            // cancel the input
            $(createInput).find('span >.cancel').click(function () {
                $(createInput).find('input').attr("disabled", true);
                $(createInput).find('button').addClass('disabled');
            });


            // editable
            $(toolbar).find('.edit > button').attr('title', options.i18n.editTip).click(function () {
                $(easyTree).find('input.easy-tree-editor').remove();
                $(easyTree).find('li > span > a:hidden').show();
                var selected = getSelectedItems();
                if (selected.length <= 0) {
                    $(toolbar).prepend(warningAlert);
                    $(toolbar).find('.alert .alert-content').html(options.i18n.editNull);
                }
                else if (selected.length > 1) {
                    $(toolbar).prepend(warningAlert);
                    $(toolbar).find('.alert .alert-content').html(options.i18n.editMultiple);
                }
                else {
                    var value = $(selected).find(' > span > a').text();
                    $(selected).find(' > span > a').hide();
                    $(selected).find(' > span').append('<input type="text" class="easy-tree-editor">');
                    var editor = $(selected).find(' > span > input.easy-tree-editor');
                    $(editor).val(value);
                    $(editor).focus();
                    $(editor).keydown(function (e) {
                        if (e.which == 13) {
                            if ($(editor).val() !== '') {
                                $(selected).find(' > span > a').text($(editor).val());
                                $(editor).remove();
                                $(selected).find(' > span > a').show();
                            }
                        }
                    });
                }
            });


            // deletable
            //$(easyTree).find('.easy-tree-toolbar').append('<div class="remove"><button class="btn btn-default btn-sm btn-danger disabled"><span class="glyphicon glyphicon-remove"></span></button></div> ');
            $(toolbar).find('.remove > button').attr('title', options.i18n.deleteTip).click(function () {
                var selected = getSelectedItems();
                if (selected.length <= 0) {
                    $(toolbar).prepend(warningAlert);
                    $(toolbar).find('.alert .alert-content').html(options.i18n.deleteNull);
                } else {
                    $(toolbar).prepend(dangerAlert);
                    $(toolbar).find('.alert .alert-content').html(options.i18n.deleteConfirmation)
                        .append('<a style="margin-left: 10px;" class="btn btn-default btn-danger confirm"></a>')
                        .find('.confirm').html(options.i18n.confirmButtonLabel);
                    $(toolbar).find('.alert .alert-content .confirm').on('click', function () {
                        $(selected).find(' ul ').remove();
                        if ($(selected).parent('ul').find(' > li').length <= 1) {
                            $(selected).parents('li').removeClass('parent_li').find(' > span > span').removeClass('glyphicon-folder-open').addClass('glyphicon-file');
                            $(selected).parent('ul').remove();
                        }
                        $(selected).remove();
                        $(dangerAlert).remove();
                    });
                }
            });


            // collapse or expand
            $(easyTree).delegate('li.parent_li > span', 'click', function (e) {
                var children = $(this).parent('li.parent_li').find(' > ul > li');
                if (children.is(':visible')) {
                    children.hide('fast');
                    $(this).attr('title', options.i18n.expandTip)
                        .find(' > span.glyphicon')
                        .addClass('glyphicon-folder-close')
                        .removeClass('glyphicon-folder-open');
                } else {
                    children.show('fast');
                    $(this).attr('title', options.i18n.collapseTip)
                        .find(' > span.glyphicon')
                        .addClass('glyphicon-folder-open')
                        .removeClass('glyphicon-folder-close');
                }
                e.stopPropagation();
            });

            // selectable, only single select
            $(easyTree).find('li > span > a').attr('title', options.i18n.selectTip);
            $(easyTree).find('li > span > a').click(function (e) {
                var li = $(this).parent().parent();
                if (li.hasClass('li_selected')) {
                    $(this).attr('title', options.i18n.selectTip);
                    $(li).removeClass('li_selected');
                }
                else {
                    $(easyTree).find('li.li_selected').removeClass('li_selected');
                    $(this).attr('title', options.i18n.unselectTip);
                    $(li).addClass('li_selected');
                }

                var selected = getSelectedItems();

                if (selected.length <= 0 || selected.length > 1) {
                    $(toolbar).find('.create > button').addClass('disabled');
                    $(toolbar).find('.edit > button').addClass('disabled');
                    $(toolbar).find('.remove > button').addClass('disabled');
                    $(createInput).find('input').attr("disabled", true);
                    $(createInput).find('button').addClass('disabled');
                }

                else {
                    $(toolbar).find('.create > button').removeClass('disabled');
                    $(toolbar).find('.edit > button').removeClass('disabled');
                    $(toolbar).find('.remove > button').removeClass('disabled');

                }

                e.stopPropagation();

            });

            // Get selected items
            var getSelectedItems = function () {
                return $(easyTree).find('li.li_selected');
            };
        });
    };
})(jQuery);