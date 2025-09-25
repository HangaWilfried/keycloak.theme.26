document.addEventListener("DOMContentLoaded", () => {
    console.log("load scripts from keycloak....");

    const passwordInput = document.getElementById("password");
    const toggleBtn = document.getElementById("togglePasswordIcon");

    let isDefaultType = true;

    const toggleShowPassword = () => {
        isDefaultType = !isDefaultType;

        if (isDefaultType) {
            passwordInput.setAttribute("type", "password");
            toggleBtn.classList.add("text-gray-500");
            toggleBtn.classList.remove("text-gray-900");
        } else {
            passwordInput.setAttribute("type", "text");
            toggleBtn.classList.remove("text-gray-500");
            toggleBtn.classList.add("text-gray-900");
        }
    };

    // brancher ton bouton :
    if (toggleBtn) {
        toggleBtn.addEventListener("click", toggleShowPassword);
    }
});
