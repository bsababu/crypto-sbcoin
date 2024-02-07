import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
import {AuthClient} from "@dfinity/auth-client"

const init = async () => { 
  const authCl = await AuthClient.create();

  if( await authCl.isAuthenticated()) {
    handleAuth(authCl);
  } else {
    await authCl.login({
      identityProvider:  "https://identity.ic0.app/#authorize",
      onSuccess: () => {
        handleAuth(authCl);
      }
    })
  }
}

async function handleAuth(AuthClient) {
  console.log(AuthClient.getIdentity());
  // const identiy = await AuthClient.getIdentity();
  // const userPrincipal = identiy._principal.toString();
  // console.log(userPrincipal);
  ReactDOM.render(<App/>, document.getElementById("root"));
}
init();


