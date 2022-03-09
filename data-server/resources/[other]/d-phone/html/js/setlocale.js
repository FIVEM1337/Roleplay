var usedlocale = 'en'
$(function() {
    window.addEventListener("message", function(event) {
        var v = event.data;

        if (v.setlocale == true) {
          var locale2 = v.locale
          usedlocale = locale2
            if (locale2 == "en") {
                $(".phone-call-incoming-title ").html(locale.callincomingtitle);
                $(".phone-call-outgoing-title ").html(locale.calloutgoingtitle);
                $(".phone-call-ongoing-title ").html(locale.callongoingtitle);
                $("#phone-contact-headline ").html(locale.phonecontactheadline);
                $("#pciheadoverview ").html(locale.pciheadoverview);
                $("#pcinumbertext ").html(locale.pcinumber);
                $("#pcicall2 ").html(locale.pcicall);
                $("#pcimessage2 ").html(locale.pcimessage);
                $("#pcifavourit2 ").html(locale.pcifavorit);
                $("#pcigps ").html(locale.pcigps);
                $("#pcishare ").html(locale.pcishare);
                $("#pcidelete ").html(locale.pcidelete);
                $("#pciheadadd ").html(locale.pciheadadd);
                $("#pciinputsubmit ").html(locale.pciinputsubmit);
                $("#pciheadedit ").html(locale.pciheadedit);
                $("#pcieditsubmit ").html(locale.pcieditsubmit);
                $("#phoneheadlinemessage ").html(locale.phoneheadlinemessage);
                $("#phoneheadlinechat ").html(locale.phoneheadlinechat);
                $("#phoneheadlinephone ").html(locale.phoneheadlinephone);
                $("#phoneheadlinesettings ").html(locale.phoneheadlinesettings);
                $(".headerbacksettings").html(locale.phoneheadlinesettings);
                $("#phonesettingsselectionflightmode ").html('<i class="fas fa-plane"></i> &nbsp' + locale.phonesettingsselectionflightmode);
                $("#phonesettingsselectionmute ").html('<i class="fas fa-volume-mute"></i> &nbsp' + locale.phonesettingsselectionmute);
                $("#phonesettingsselectiondarkmode ").html('<i class="fas fa-adjust"></i> &nbsp' + locale.phonesettingsselectiondarkmode);
                $("#phonesettingsselectionwallpaper ").html('<i class="fas fa-image"></i> &nbsp' + locale.phonesettingsselectionwallpaper);
                $("#phone-settings-selection-changecase ").html('<i class="fas fa-mobile"></i> &nbsp' + locale.phonesettingsselectioncase);
                $("#phonesettingsselectionringtone").html('<i class="fas fa-bell"></i> &nbsp' +locale.phonesettingsselectionringtone);
                $("#pswh ").html(locale.pswh);
                $("#pswsubmitbutton ").html(locale.pswsubmitbutton);
                $("#phservice ").html(locale.phservice);
                $("#psmn ").html(locale.psmn);
                $("#pss ").html(locale.pss);
                $("#pssposition ").html(locale.pssposition);
                $("#phone-service-button ").html(locale.phoneservicebutton);
                $("#phbusiness ").html(locale.phbusiness);
                $("#motdchange ").html(locale.motdchange);
                $("#pbbacceptfont ").html(locale.pbbacceptfont);
                $("#pbbacceptfont2 ").html(locale.pbbacceptfont2);
                $("#pbsjobnumber ").html(locale.jobnumber);
                $("#pbsmfont ").html(locale.motdchange);
                $("#pbsmfont2 ").html(locale.pbsmfont2);
                $("#pbsmfont3 ").html(locale.pbsmfont3);
                $("#pbsjobmoney ").html(locale.pbsjobmoney);
                $("#phfunk ").html(locale.phfunk);
                $("#phone-frequenz-join-button ").html(locale.pfjb);
                $("#phone-frequenz-leave-button ").html(locale.pflb);
                $("#phonesettingsnumbertext ").html("<i class='fas fa-phone-alt'></i> &nbsp" + locale.phonenumber);
                $(".ptw-submit ").each(function() {
                    $(this).html(locale.ptwtweetsubmit);
                });
                $(".twitter-firsttime-button ").html(locale.ptwtweetsubmit);
                $(".ptw-pbsubmit ").each(function() {
                    $(this).html(locale.ptwtweetsubmit);
                });
                $("#phoneheadlinetwitter ").html(locale.phoneheadlinetwitter);
                $("#ptw-tweetheader-font ").html(locale.ptwtweetheaderfont);
                $("#ptw-header-font ").html(locale.ptwheaderfont);
                $("#ptw-header-font2 ").html(locale.ptwheaderfont2);
                $("#ptw-header-font3 ").html(locale.ptwheaderfont3);
                $("#ptw-header-font4 ").html(locale.ptwheaderfont4);
                $("#ptw-header-font5 ").html(locale.ptwheaderfont5);
                $("#ptw-header-font6 ").html(locale.ptwheaderfont3);
                $("#ptw-header-font7 ").html(locale.ptwheaderfont7);
                $("#phonetwitternotification ").html(locale.tweetnotificaton);
            
                // 0.60
                // Banking app
                $("#bankapp-headline").html(locale.bankappheadline);
                $(".phone-bankapp-cards-headline").html(locale.phonebankappcardsheadline);
                $(".phone-card-cardholder").html(locale.cardcardholder);
                $(".phone-card-expires").html(locale.cardexpires);
                $(".phone-bankapp-cards-headline").html(locale.phonebankappcardsheadline);
                $(".bankapp-transfer-headline").html(locale.bankapptransferheadline);
                $(".bankapp-transfer-cardnumber").html(locale.bankapptransfercardnumber);
                $(".bankapp-transfer-amount").html(locale.bankapptransferamount);
                $(".bankapp-transfer-button").html(locale.bankapptransferbutton);
            
                // 0.61
                // Businessapp
                $("#pbrs-headlineheadline").html(locale.magnagment);
                $("#pbrs-nameheadline").html(locale.pbrsnameheadline);
                $("#pbrs-gradeheadline").html(locale.pbrsgradeheadline);
                $("#pbrs-rankheadline").html(locale.pbrsrankheadline);
                $("#pbrs-uprank").html(locale.pbrsuprank);
                $("#pbrs-derank").html(locale.pbrsderank);
                $("#pbrs-updaterank").html(locale.pbrsupdaterank);
                $("#pbrs-fire").html(locale.pbrsfire);
                $("#pbrs-recruitheadline").html(locale.pbrsrecruitheadline);
                $("#pbrs-recruit").html(locale.pbrsrecruit);
                $("#pbms-headlineheadline").html(locale.pbmsheadlineheadline);
                $("#pbms-nameheadline").html(locale.pbmsnameheadline);
                $("#pmbs-deposit").html(locale.pmbsdeposit);
                $("#pmbs-withdraw").html(locale.pmbswithdraw);
            
                // 0.7
                $("#prmsheadline").html(locale.prmsheadline);
                $("#prmsdelete").html(locale.prmsdelete);
            
                // 0.73
                $("#phone-app-contact-page-add").html(locale.add);
                $("#phone-app-contact-page-edit").html(locale.edit);
                $("#phone-app-contact-headline").html(locale.phonecontactheadline);
                $(".phone-app-contact-page-contact").each(function() {
                    $(this).html(locale.contact);
                });
                $(".firstname").each(function() {
                    $(this).html(locale.firstname);
                });
                $(".lastname").each(function() {
                    $(this).html(locale.lastname);
                });
                $(".phonenumber").each(function() {
                    $(this).html(locale.phonenumber);
                });
                $(".numbertext").each(function() {
                    $(this).html(locale.number);
                });
                $(".timetext").each(function() {
                    $(this).html(locale.time);
                });
                $("#phone-app-contact-edit-delete").html(locale.delete);
                $("#phone-app-edit-newcontact").html(locale.pciheadedit);
                $("#phone-recent-message-edit").html(locale.edit);
                $("#phone-app-contact-new-editbutton").html(locale.save2);
                $("#phone-app-contact-new-savebutton").html(locale.save2);
                $(".phone-app-contact-page-sendlocatoin").html(locale.sendlocation);
                $("#phone-app-contact-page-sharecontact").html(locale.sharecontact);
                $("#phone-app-contact-page-delete").html(locale.deletecontact);
            
                // Placeholder
                $('#pbms-amount').attr("placeholder", locale.pbmsamount);
                $('#inputcardnumber').attr("placeholder", locale.placeholdercardnumber);
                $('#inputtransferamoutn').attr("placeholder", locale.placeholderamount);
                $('#pciinputname').attr("placeholder", locale.name);
                $('#pciinputname2').attr("placeholder", locale.name);
                $('#pciinputnumber').attr("placeholder", locale.number);
                $('#pciinputnumber2').attr("placeholder", locale.number);
                $('#phone-chat-input-message').attr("placeholder", locale.message);
                $('#psw').attr("placeholder", locale.png);
                $('.phone-service-message-input').attr("placeholder", locale.description);
                $('#phone-business-input-message').attr("placeholder", locale.message);
                $('#motd').attr("placeholder", locale.message);
                $('#ptw-tweetinput').attr("placeholder", locale.message);
                $('#phone-radio-frequenz-input').attr("placeholder", locale.frequency);
                $('#ptw-imageurl').attr("placeholder", locale.url);
                $('#ptw-pbinput').attr("placeholder", locale.url);
                $('#ptw-username').attr("placeholder", locale.name);
                $('#ptw-ftavatarurl').attr("placeholder", locale.url);
                $('#ptw-ftusername').attr("placeholder", locale.name);
                $('#ptw-ftid').attr("placeholder", locale.name);
            
                // Lifeinvader
                $("#advertisement-headline").html(locale.advertisementheadline);
                $("#abtext").html(locale.abtext);
                $("#yourname").html(locale.yourname);
                $("#abmessage").html(locale.abmessage);
                $("#advertisement-sendnewmessage").html(locale.advertisementsendnewmessage);
            
                // Market
                $("#dmarketheadline").html(locale.dmarketheadline);
                $("#price").html(locale.price);
                $("#stock").html(locale.stock);
            
                // 0.72
                $("#phone-constant-radio").html(locale.enableconstant);
            
                // 0.73
                $(".phone-app-call-historyheadline").html(locale.callhistoryheadline)
            }
            
            if ( locale2 == "de" ) {
                $(".phone-call-incoming-title ").html(localede.callincomingtitle);
                $(".phone-call-outgoing-title ").html(localede.calloutgoingtitle);
                $(".phone-call-ongoing-title ").html(localede.callongoingtitle);
                $("#phone-contact-headline ").html(localede.phonecontactheadline);
                $("#pciheadoverview ").html(localede.pciheadoverview);
                $("#pcinumbertext ").html(localede.pcinumber);
                $("#pcicall2 ").html(localede.pcicall);
                $("#pcimessage2 ").html(localede.pcimessage);
                $("#pcifavourit2 ").html(localede.pcifavorit);
                $("#pcigps ").html(localede.pcigps);
                $("#pcishare ").html(localede.pcishare);
                $("#pcidelete ").html(localede.pcidelete);
                $("#pciheadadd ").html(localede.pciheadadd);
                $("#pciinputsubmit ").html(localede.pciinputsubmit);
                $("#pciheadedit ").html(localede.pciheadedit);
                $("#pcieditsubmit ").html(localede.pcieditsubmit);
                $("#phoneheadlinemessage ").html(localede.phoneheadlinemessage);
                $("#phoneheadlinechat ").html(localede.phoneheadlinechat);
                $("#phoneheadlinephone ").html(localede.phoneheadlinephone);
                $("#phoneheadlinesettings ").html(localede.phoneheadlinesettings);
                $(".headerbacksettings").html(localede.phoneheadlinesettings);
                $("#phonesettingsselectionflightmode ").html('<i class="fas fa-plane"></i> &nbsp' + localede.phonesettingsselectionflightmode);
                $("#phonesettingsselectionmute ").html('<i class="fas fa-volume-mute"></i> &nbsp' + localede.phonesettingsselectionmute);
                $("#phonesettingsselectiondarkmode ").html('<i class="fas fa-adjust"></i> &nbsp' + localede.phonesettingsselectiondarkmode);
                $("#phonesettingsselectionwallpaper ").html('<i class="fas fa-image"></i> &nbsp' + localede.phonesettingsselectionwallpaper);
                $("#phone-settings-selection-changecase ").html('<i class="fas fa-mobile"></i> &nbsp' + localede.phonesettingsselectioncase);
                $("#phonesettingsselectionringtone ").html('<i class="fas fa-bell"></i> &nbsp' + localede.phonesettingsselectionringtone);
                $("#pswh ").html(localede.pswh);
                $("#pswsubmitbutton ").html(localede.pswsubmitbutton);
                $("#phservice ").html(localede.phservice);
                $("#psmn ").html(localede.psmn);
                $("#pss ").html(localede.pss);
                $("#pssposition ").html(localede.pssposition);
                $("#phone-service-button ").html(localede.phoneservicebutton);
                $("#phbusiness ").html(localede.phbusiness);
                $("#motdchange ").html(localede.motdchange);
                $("#pbbacceptfont ").html(localede.pbbacceptfont);
                $("#pbbacceptfont2 ").html(localede.pbbacceptfont2);
                $("#pbsjobnumber ").html(localede.jobnumber);
                $("#pbsmfont ").html(localede.motdchange);
                $("#pbsmfont2 ").html(localede.pbsmfont2);
                $("#pbsmfont3 ").html(localede.pbsmfont3);
                $("#pbsjobmoney ").html(localede.pbsjobmoney);
                $("#phfunk ").html(localede.phfunk);
                $("#phone-frequenz-join-button ").html(localede.pfjb);
                $("#phone-frequenz-leave-button ").html(localede.pflb);
                $("#phonesettingsnumbertext ").html("<i class='fas fa-phone-alt'></i> &nbsp" + localede.phonenumber);
                $(".ptw-submit ").each(function() {
                    $(this).html(localede.ptwtweetsubmit);
                });
                $(".twitter-firsttime-button ").html(localede.ptwtweetsubmit);
                $(".ptw-pbsubmit ").each(function() {
                    $(this).html(localede.ptwtweetsubmit);
                });
                $("#phoneheadlinetwitter ").html(localede.phoneheadlinetwitter);
                $("#ptw-tweetheader-font ").html(localede.ptwtweetheaderfont);
                $("#ptw-header-font ").html(localede.ptwheaderfont);
                $("#ptw-header-font2 ").html(localede.ptwheaderfont2);
                $("#ptw-header-font3 ").html(localede.ptwheaderfont3);
                $("#ptw-header-font4 ").html(localede.ptwheaderfont4);
                $("#ptw-header-font5 ").html(localede.ptwheaderfont5);
                $("#ptw-header-font6 ").html(localede.ptwheaderfont3);
                $("#ptw-header-font7 ").html(localede.ptwheaderfont7);
                $("#phonetwitternotification ").html(localede.tweetnotificaton);
            
                // 0.60
                // Banking app
                $("#bankapp-headline").html(localede.bankappheadline);
                $(".phone-bankapp-cards-headline").html(localede.phonebankappcardsheadline);
                $(".phone-card-cardholder").html(localede.cardcardholder);
                $(".phone-card-expires").html(localede.cardexpires);
                $(".phone-bankapp-cards-headline").html(localede.phonebankappcardsheadline);
                $(".bankapp-transfer-headline").html(localede.bankapptransferheadline);
                $(".bankapp-transfer-cardnumber").html(localede.bankapptransfercardnumber);
                $(".bankapp-transfer-amount").html(localede.bankapptransferamount);
                $(".bankapp-transfer-button").html(localede.bankapptransferbutton);
            
                // 0.61
                // Businessapp
                $("#pbrs-headlineheadline").html(localede.magnagment);
                $("#pbrs-nameheadline").html(localede.pbrsnameheadline);
                $("#pbrs-gradeheadline").html(localede.pbrsgradeheadline);
                $("#pbrs-rankheadline").html(localede.pbrsrankheadline);
                $("#pbrs-uprank").html(localede.pbrsuprank);
                $("#pbrs-derank").html(localede.pbrsderank);
                $("#pbrs-updaterank").html(localede.pbrsupdaterank);
                $("#pbrs-fire").html(localede.pbrsfire);
                $("#pbrs-recruitheadline").html(localede.pbrsrecruitheadline);
                $("#pbrs-recruit").html(localede.pbrsrecruit);
                $("#pbms-headlineheadline").html(localede.pbmsheadlineheadline);
                $("#pbms-nameheadline").html(localede.pbmsnameheadline);
                $("#pmbs-deposit").html(localede.pmbsdeposit);
                $("#pmbs-withdraw").html(localede.pmbswithdraw);
            
                // 0.7
                $("#prmsheadline").html(localede.prmsheadline);
                $("#prmsdelete").html(localede.prmsdelete);
            
                // 0.73
                $("#phone-app-contact-page-add").html(localede.add);
                $("#phone-app-contact-page-edit").html(localede.edit);
                $("#phone-app-contact-headline").html(localede.phonecontactheadline);
                $(".phone-app-contact-page-contact").each(function() {
                    $(this).html(localede.contact);
                });
                $(".firstname").each(function() {
                    $(this).html(localede.firstname);
                });
                $(".lastname").each(function() {
                    $(this).html(localede.lastname);
                });
                $(".phonenumber").each(function() {
                    $(this).html(localede.phonenumber);
                });
                $(".numbertext").each(function() {
                    $(this).html(localede.number);
                });
                $(".timetext").each(function() {
                    $(this).html(localede.time);
                });
                $("#phone-app-contact-edit-delete").html(localede.delete);
                $("#phone-app-edit-newcontact").html(localede.pciheadedit);
                $("#phone-recent-message-edit").html(localede.edit);
                $("#phone-app-contact-new-editbutton").html(localede.save2);
                $("#phone-app-contact-new-savebutton").html(localede.save2);
                $(".phone-app-contact-page-sendlocatoin").html(localede.sendlocation);
                $("#phone-app-contact-page-sharecontact").html(localede.sharecontact);
                $("#phone-app-contact-page-delete").html(localede.deletecontact);
            
                // Placeholder
                $('#pbms-amount').attr("placeholder", localede.pbmsamount);
                $('#inputcardnumber').attr("placeholder", localede.placeholdercardnumber);
                $('#inputtransferamoutn').attr("placeholder", localede.placeholderamount);
                $('#pciinputname').attr("placeholder", localede.name);
                $('#pciinputname2').attr("placeholder", localede.name);
                $('#pciinputnumber').attr("placeholder", localede.number);
                $('#pciinputnumber2').attr("placeholder", localede.number);
                $('#phone-chat-input-message').attr("placeholder", localede.message);
                $('#psw').attr("placeholder", localede.png);
                $('.phone-service-message-input').attr("placeholder", localede.description);
                $('#phone-business-input-message').attr("placeholder", localede.message);
                $('#motd').attr("placeholder", localede.message);
                $('#ptw-tweetinput').attr("placeholder", localede.message);
                $('#phone-radio-frequenz-input').attr("placeholder", localede.frequency);
                $('#ptw-imageurl').attr("placeholder", localede.url);
                $('#ptw-pbinput').attr("placeholder", localede.url);
                $('#ptw-username').attr("placeholder", localede.name);
                $('#ptw-ftavatarurl').attr("placeholder", localede.url);
                $('#ptw-ftusername').attr("placeholder", localede.name);
                $('#ptw-ftid').attr("placeholder", localede.name);
            
                // Lifeinvader
                $("#advertisement-headline").html(localede.advertisementheadline);
                $("#abtext").html(localede.abtext);
                $("#yourname").html(localede.yourname);
                $("#abmessage").html(localede.abmessage);
                $("#advertisement-sendnewmessage").html(localede.advertisementsendnewmessage);
            
                // Market
                $("#dmarketheadline").html(localede.dmarketheadline);
                $("#price").html(localede.price);
                $("#stock").html(localede.stock);
            
                // 0.72
                $("#phone-constant-radio").html(localede.enableconstant);
            
                // 0.73
                $(".phone-app-call-historyheadline").html(localede.callhistoryheadline)
            }
        } 
    });
});

