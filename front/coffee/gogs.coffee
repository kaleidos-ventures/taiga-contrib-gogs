@.taigaContribPlugins = @.taigaContribPlugins or []

gogsInfo = {
    slug: "gogs"
    name: "Gogs"
    type: "admin"
    module: 'taigaContrib.gogs'
}

@.taigaContribPlugins.push(gogsInfo)

module = angular.module('taigaContrib.gogs', [])

debounce = (wait, func) ->
    return _.debounce(func, wait, {leading: true, trailing: false})

initGogsPlugin = ($tgUrls) ->
    $tgUrls.update({
        "gogs": "/gogs-hook"
    })

class GogsAdmin
    @.$inject = [
        "$rootScope",
        "$scope",
        "$tgResources"
        "tgAppMetaService",
        "$tgConfirm",
    ]

    constructor: (@rootScope, @scope, @rs, @appMetaService, @confirm) ->
        @scope.sectionName = "Gogs" # i18n
        @scope.sectionSlug = "gogs"

        @scope.$on 'project:loaded', =>
            promise = @rs.modules.list(@scope.projectId, "gogs")

            promise.then (gogs) =>
                @scope.gogs = gogs

                title = "#{@scope.sectionName} - Plugins - #{@scope.project.name}" # i18n
                description = @scope.project.description
                @appMetaService.setAll(title, description)

            promise.then null, =>
                @confirm.notify("error")

module.controller("ContribGogsAdminController", GogsAdmin)

GogsWebhooksDirective = ($repo, $confirm, $loading) ->
    link = ($scope, $el, $attrs) ->
        form = $el.find("form").checksley({"onlyOneErrorElement": true})
        submit = debounce 2000, (event) =>
            event.preventDefault()

            return if not form.validate()

            currentLoading = $loading()
                .target(submitButton)
                .start()

            promise = $repo.saveAttribute($scope.gogs, "gogs")
            promise.then ->
                currentLoading.finish()
                $confirm.notify("success")
                $scope.$emit("project:modules:reload")

            promise.then null, (data) ->
                currentLoading.finish()
                form.setErrors(data)
                if data._error_message
                    $confirm.notify("error", data._error_message)

        submitButton = $el.find(".submit-button")

        $el.on "submit", "form", submit
        $el.on "click", ".submit-button", submit

    return {link:link}

module.directive("contribGogsWebhooks", ["$tgRepo", "$tgConfirm", "$tgLoading", GogsWebhooksDirective])

module.run(["$tgUrls", initGogsPlugin])
