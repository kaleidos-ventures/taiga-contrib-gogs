@.taigaContribPlugins = @.taigaContribPlugins or []

gogsInfo = {
    slug: "gogs"
    name: "Gogs"
    type: "admin"
    adminController: "ContribGogsAdmin"
    adminPartial: "contrib/gogs/admin.html"
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
        "$tgModel",
        "$tgRepo",
        "$tgResources"
        "$routeParams",
        "$appTitle"
    ]

    constructor: (@rootScope, @scope, @model, @repo, @rs, @params, @appTitle, @confirm) ->
        @scope.sectionName = "Gogs" #i18n
        @scope.project = {}
        @scope.adminPlugins = _.filter(@rootScope.contribPlugins, (plugin) -> plugin.type == "admin")

        promise = @.loadInitialData()

        promise.then () =>
            @appTitle.set("Gogs - " + @scope.project.name)

        promise.then null, =>
            @confirm.notify("error")

    loadGogsHooks: ->
        return @rs.modules.list(@scope.projectId, "gogs").then (gogs) =>
            @scope.gogs = gogs

    loadProject: ->
        return @rs.projects.get(@scope.projectId).then (project) =>
            @scope.project = project
            @scope.$emit('project:loaded', project)
            return project

    loadInitialData: ->
        promise = @repo.resolve({pslug: @params.pslug}).then (data) =>
            @scope.projectId = data.project
            return data

        return promise.then(=> @.loadProject())
                      .then(=> @.loadGogsHooks())

module.controller("ContribGogsAdminController", GogsAdmin)

GogsWebhooksDirective = ($repo, $confirm, $loading) ->
    link = ($scope, $el, $attrs) ->
        form = $el.find("form").checksley({"onlyOneErrorElement": true})
        submit = debounce 2000, (event) =>
            event.preventDefault()

            return if not form.validate()

            $loading.start(submitButton)

            if $scope.gogshook.id
                promise = $repo.save($scope.gogshook)
            else
                promise = $repo.create("gogs", $scope.gogshook)
            promise.then ->
                $loading.finish(submitButton)
                $confirm.notify("success")

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
