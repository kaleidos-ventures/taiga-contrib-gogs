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
        "$appTitle",
        "$tgConfirm",
    ]

    constructor: (@rootScope, @scope, @rs, @appTitle, @confirm) ->
        @scope.sectionName = "Gogs"
        @scope.sectionSlug = "gogs"

        @scope.$on 'project:loaded', =>
            promise = @rs.modules.list(@scope.projectId, "gogs")

            promise.then (gogs) =>
                @scope.gogs = gogs
                @appTitle.set("Gogs - " + @scope.project.name)

            promise.then null, =>
                @confirm.notify("error")

module.controller("ContribGogsAdminController", GogsAdmin)

GogsWebhooksDirective = ($repo, $confirm, $loading) ->
    link = ($scope, $el, $attrs) ->
        form = $el.find("form").checksley({"onlyOneErrorElement": true})
        submit = debounce 2000, (event) =>
            event.preventDefault()

            return if not form.validate()

            $loading.start(submitButton)

            promise = $repo.saveAttribute($scope.gogs, "gogs")
            promise.then ->
                $loading.finish(submitButton)
                $confirm.notify("success")
                $scope.$emit("project:modules:reload")

            promise.then null, (data) ->
                $loading.finish(submitButton)
                form.setErrors(data)
                if data._error_message
                    $confirm.notify("error", data._error_message)

        submitButton = $el.find(".submit-button")

        $el.on "submit", "form", submit
        $el.on "click", ".submit-button", submit

    return {link:link}

module.directive("contribGogsWebhooks", ["$tgRepo", "$tgConfirm", "$tgLoading", GogsWebhooksDirective])

module.run(["$tgUrls", initGogsPlugin])
