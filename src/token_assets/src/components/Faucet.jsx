import React, { useState } from "react";
import {token, createActor, canisterId} from "../../../declarations/token";
import {AuthClient} from "@dfinity/auth-client"


function Faucet() {

  const [isDisabled, setDisable] = useState(false);
  const [buttonText, setButText] = useState("Reward me");

  async function handleClick(event) {
    setDisable(true);
    //await token.payOut();
    //setDisable(false);
    const authCl = await AuthClient.create();
    const identiy = await AuthClient.getIdentity();
    const userPrincipal = identiy._principal.toString();
    const authCanister = createActor(canisterId, {
      agentOptions: {
        identiy
      },

    });

    const txt = await authCanister.payOut();
    setButText(txt);
  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>Get your free Sababu tokens here! Claim 20,000 <strong><blink>SBCOIN</blink></strong> to your account.</label>
      <p className="trade-buttons">
        <button id="btn-payout" onClick={handleClick} disabled={isDisabled}>
          {buttonText}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
