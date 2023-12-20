HD.Target = {
    AddEntity = function(entity,data)
        if Config.TargetSystem == "qb-target" or Config.TargetSystem == "qtarget" then
        exports[Config.TargetSystem]:AddTargetEntity(entity, {
            options = data.Options,
            distance = (data.Distance or 1.5)
        })
        elseif Config.TargetSystem == "ox_target" then
        for k,v in pairs(data.Options) do
            data.Options[k].onSelect = v.action
        end
        if not data.Local then
            return exports['ox_target']:addEntity(entity, data.Options)
        else
            return exports['ox_target']:addLocalEntity(entity, data.Options)
        end
        end
    end,

    RemoveEntity = function(entity, net)
        if Config.TargetSystem == "qb-target" or Config.TargetSystem == "qtarget" then
          exports[Config.TargetSystem]:RemoveTargetEntity(entity)
        elseif Config.TargetSystem == "ox_target" then
          if not net then
            exports.ox_target:removeLocalEntity(entity)
          else
            exports.ox_target:removeEntity(entity)
          end
        end
    end,

    RemoveZone = function(name)
        if Config.TargetSystem == "qb-target" or Config.TargetSystem == "qtarget" then
            exports['qb-target']:RemoveZone(name)
        elseif Config.TargetSystem == "ox_target" then
            exports.ox_target:removeZone(name)
        end
    end,
}