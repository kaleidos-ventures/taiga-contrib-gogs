###
# Copyright (C) 2014-2016 Andrey Antukh <niwi@niwi.nz>
# Copyright (C) 2014-2016 Jesús Espino Garcia <jespinog@gmail.com>
# Copyright (C) 2014-2016 David Barragán Merino <bameda@dbarragan.com>
# Copyright (C) 2014-2016 Alejandro Alonso <alejandro.alonso@kaleidos.net>
# Copyright (C) 2014-2016 Juan Francisco Alcántara <juanfran.alcantara@kaleidos.net>
# Copyright (C) 2014-2016 Xavi Julian <xavier.julian@kaleidos.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: gogs.coffee
###
debounce = (wait, func) ->
    return _.debounce(func, wait, {leading: true, trailing: false})

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


module = angular.module('taigaContrib.gogs', [])

module.controller("ContribGogsAdminController", GogsAdmin)
module.directive("contribGogsWebhooks", ["$tgRepo", "$tgConfirm", "$tgLoading", GogsWebhooksDirective])

initGogsPlugin = ($tgUrls) ->
    $tgUrls.update({
        "gogs": "/gogs-hook"
    })
module.run(["$tgUrls", initGogsPlugin])
