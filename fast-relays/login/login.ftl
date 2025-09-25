<#import "template.ftl" as layout>
<#import "passkeys.ftl" as passkeys>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
     <#if section="header">
     <#elseif section="form">
         <div class="min-h-screen overflow-hidden relative pt-20 font-roboto">
             <div class="fixed w-full top-0 z-[1] h-screen opacity-30 bg-black"></div>
             <span class="z-[-1] absolute -top-96 left-0 size-96 rounded-full bg-transparent shadow-red3"></span>
             <span class="z-[-1] absolute -bottom-96 right-0 size-96 rounded-full bg-transparent shadow-blue3"></span>

             <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" class="bg-white z-10 relative rounded-lg p-7 flex flex-col gap-4 m-auto w-[90%] max-w-xl shadow">
                 <h3 class="flex justify-center">
                     <a href="${client.baseUrl}" class="bg-gradient-to-r from-blue-600 to-red-600 text-3xl font-medium flex gap-1 items-center z-5 bg-clip-text text-transparent">
                         <span>Fast-</span>
                         <span>Relays</span>
                     </a>
                 </h3>

                 <div class="flex flex-col gap-1">
                     <h1 class="text-xl font-medium">${msg("loginTitle")}</h1>
                     <span class="text-sm">${msg("howToLogIn")}</span>
                 </div>

                 <#if realm.password>
                     <#if !usernameHidden??>
                         <label for="username" class="flex flex-col gap-2">
                             <span><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></span>
                             <input tabindex="2" id="username" name="username" value="${(login.username!'')}" type="text"
                                    autofocus autocomplete="${(enableWebAuthnConditionalUI?has_content)?then('username webauthn', 'username')}"
                                    aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                    dir="ltr"
                                    class="pl-2 outline-none focus:outline-none focus:ring-2 h-10 rounded-lg border <#if messagesPerField.existsError('username','password')>border-red-600 focus:ring-red-300 <#else> border-gray-300 focus:ring-blue-300 focus:border-blue-500 </#if>"
                             />
                         </label>
                     </#if>

                     <div class="flex flex-col gap-2 mb-4">
                         <label for="password" class="flex flex-col gap-2">
                             <span>${msg("password")}</span>
                             <div class="relative" dir="ltr">
                                 <input tabindex="3" id="password" name="password" type="password" autocomplete="current-password"
                                        aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                        class="pl-2 outline-none focus:outline-none focus:ring-2 h-10 rounded-lg w-full <#if messagesPerField.existsError('username','password')> border border-red-600 focus:ring-red-300 <#else> border border-gray-300 focus:ring-blue-300 focus:border-blue-500 </#if>"
                                 />
                                 <svg
                                         xmlns="http://www.w3.org/2000/svg"
                                         fill="none"
                                         viewBox="0 0 24 24"
                                         stroke-width="1.5"
                                         stroke="currentColor"
                                         id="togglePasswordIcon"
                                         class="size-5 text-gray-500 cursor-pointer absolute right-3 top-1/2 transform -translate-y-1/2"
                                 >
                                     <path
                                             stroke-linecap="round"
                                             stroke-linejoin="round"
                                             d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99"
                                     />
                                 </svg>
                             </div>
                         </label>

                         <#if realm.resetPasswordAllowed>
                             <div class="flex gap-1 items-center justify-end text-sm text-blue-600 underline">
                                 <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-5">
                                     <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
                                 </svg>
                                 <a tabindex="6" href="${client.baseUrl}/auth/forgot-password">${msg("doForgotPassword")}</a>
                             </div>
                         </#if>
                     </div>

                     <#if messagesPerField.existsError('username','password')>
                         <span class="text-sm text-red-600">
                            ${msg("invalidCredentials")}
                        </span>
                     </#if>

                     <#if realm.rememberMe && !usernameHidden??>
                         <div class="checkbox">
                             <label class="flex items-center gap-2">
                                 <#if login.rememberMe??>
                                     <input tabindex="5" id="rememberMe" name="rememberMe" type="checkbox" checked>
                                 <#else>
                                     <input tabindex="5" id="rememberMe" name="rememberMe" type="checkbox">
                                 </#if>
                                 ${msg("rememberMe")}
                             </label>
                         </div>
                     </#if>

                     <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>

                     <button tabindex="7" name="login" id="kc-login" type="submit"
                             class="text-white p-2 rounded-lg bg-gradient-to-r from-blue-900 to-sky-600 font-bold w-full">
                         ${msg("doLogIn")}
                     </button>
                 </#if>

                 <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
                     <div class="flex gap-1 items-center justify-center">
                         <span>${msg("noAccount")}</span>
                         <a tabindex="8" href="${client.baseUrl}/auth/new-account" class="font-medium underline underline-offset-4 text-blue-600">
                             ${msg("doRegister")}
                         </a>
                     </div>
                 </#if>
             </form>
         </div>
         <@passkeys.conditionalUIData />
         <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
         <#if realm.password && social?? && social.providers?has_content>
             <div class="bg-white z-10 relative rounded-lg p-7 flex flex-col gap-4 m-auto w-[90%] max-w-xl shadow mt-4">
                 <hr/>
                 <h2 class="text-center">${msg("identity-provider-login-label")}</h2>

                 <ul class="flex flex-col gap-2 <#if social.providers?size gt 3>grid grid-cols-2 gap-4</#if>">
                     <#list social.providers as p>
                         <li>
                             <a data-once-link data-disabled-class="opacity-50" id="social-${p.alias}"
                                class="flex items-center justify-center p-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
                                type="button" href="${p.loginUrl}">
                                 <#if p.iconClasses?has_content>
                                     <i class="${properties.kcCommonLogoIdP!} ${p.iconClasses!} mr-2" aria-hidden="true"></i>
                                     <span>${p.displayName!}</span>
                                 <#else>
                                     <span>${p.displayName!}</span>
                                 </#if>
                             </a>
                         </li>
                     </#list>
                 </ul>
             </div>
         </#if>
     </#if>
</@layout.registrationLayout>