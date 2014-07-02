###*
* @file
* Overrides for CTools modal.
* See ctools/js/modal.js
###
(($) ->

  ###
  Override CTools modal show function so it can recognize
  the Bootstrap modal classes correctly
  ###
  window.Drupal ?= {}
  Drupal.CTools ?= {}
  # quickly shims to make sure the object is available.
  if Drupal.CTools.Modal?
    Drupal.CTools.Modal.show = (choice) ->
      opts = {}
      if choice and typeof choice is "string" and Drupal.settings[choice]

        # This notation guarantees we are actually copying it.
        $.extend true, opts, Drupal.settings[choice]
      else $.extend true, opts, choice  if choice
      defaults =
        modalTheme: "CToolsModalDialog"
        throbberTheme: "CToolsModalThrobber"
        animation: "show"
        animationSpeed: "fast"
        modalSize:
          type: "scale"
          width: 0.8
          height: 0.8
          addWidth: 0
          addHeight: 0

          # How much to remove from the inner content to make space for the
          # theming.
          contentRight: 25
          contentBottom: 45

        modalOptions:
          opacity: 0.55
          background: "#fff"

      settings = {}
      $.extend true, settings, defaults, Drupal.settings.CToolsModal, opts
      if Drupal.CTools.Modal.currentSettings and Drupal.CTools.Modal.currentSettings isnt settings
        Drupal.CTools.Modal.modal.remove()
        Drupal.CTools.Modal.modal = null
      Drupal.CTools.Modal.currentSettings = settings
      resize = (e) ->

        # When creating the modal, it actually exists only in a theoretical
        # place that is not in the DOM. But once the modal exists, it is in the
        # DOM so the context must be set appropriately.
        context = (if e then document else Drupal.CTools.Modal.modal)
        if Drupal.CTools.Modal.currentSettings.modalSize.type is "scale"
          width = $(window).width() * Drupal.CTools.Modal.currentSettings.modalSize.width
          height = $(window).height() * Drupal.CTools.Modal.currentSettings.modalSize.height
        else
          width = Drupal.CTools.Modal.currentSettings.modalSize.width
          height = Drupal.CTools.Modal.currentSettings.modalSize.height

        # Use the additionol pixels for creating the width and height.
        $("div.ctools-modal-dialog", context).css
          width: width + Drupal.CTools.Modal.currentSettings.modalSize.addWidth + "px"
          height: height + Drupal.CTools.Modal.currentSettings.modalSize.addHeight + "px"

        $("div.ctools-modal-dialog .modal-body", context).css
          width: (width - Drupal.CTools.Modal.currentSettings.modalSize.contentRight) + "px"
          height: (height - Drupal.CTools.Modal.currentSettings.modalSize.contentBottom) + "px"

        return

      unless Drupal.CTools.Modal.modal
        Drupal.CTools.Modal.modal = $(Drupal.theme(settings.modalTheme))
        $(window).bind "resize", resize  if settings.modalSize.type is "scale"

      # First, let's get rid of the body overflow.
      $("body").addClass "modal-open"
      resize()
      $(".modal-title", Drupal.CTools.Modal.modal).html Drupal.CTools.Modal.currentSettings.loadingText
      Drupal.CTools.Modal.modalContent Drupal.CTools.Modal.modal, settings.modalOptions, settings.animation, settings.animationSpeed
      $("#modalContent .modal-body").html Drupal.theme(settings.throbberTheme)
      return

    Drupal.CTools.Modal.dismiss = ->
      console.log "oi"
      if Drupal.CTools.Modal.modal
        $("body").removeClass "modal-open"
        Drupal.CTools.Modal.unmodalContent Drupal.CTools.Modal.modal
      return

    Drupal.theme ?= ->
    ###
    Provide the HTML for the Modal.
    ###
    Drupal.theme::CToolsModalDialog = ->
      html = ""
      html += "  <div id=\"ctools-modal\">"
      html += "    <div class=\"ctools-modal-dialog modal-dialog\">"
      html += "      <div class=\"modal-content\">"
      html += "        <div class=\"modal-header\">"
      html += "          <button type=\"button\" class=\"close ctools-close-modal\">"
      html += "           <span aria-hidden=\"true\">&times;</span>"
      html += "           <span class=\"sr-only\">Close</span></button>"
      html += "          <h4 id=\"modal-title\" class=\"modal-title\">&nbsp;</h4>"
      html += "        </div>"
      html += "        <div id=\"modal-content\" class=\"modal-body\">"
      html += "        </div>"
      html += "      </div>"
      html += "    </div>"
      html += "  </div>"
      html


    ###
    Provide the HTML for Modal Throbber.
    ###
    Drupal.theme::CToolsModalThrobber = ->
      html = ""
      html += "  <div class=\"loading-spinner\" style=\"position: absolute; top: 45%; left: 50%\">"
      html += "    <i class=\"fa fa-cog fa-spin fa-3x\"></i>"
      html += "  </div>"
      html

  return
) jQuery
