Locales = Locales or {}
function Locales.get(messageCode)
    local localeMessages = Locales[Config.Locale]
    if localeMessages then
        return localeMessages[messageCode] or ("Unknown message code '%s'"):format(messageCode)
    else
        return ("Unknown locale '%s'"):format(Config.Locale)
    end
    return Locales[Config.Locale][messageCode]
end