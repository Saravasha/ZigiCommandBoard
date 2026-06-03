// app.jsx
import { useEffect, useState } from "react";
import appReadySound from "./assets/appReady.wav";
import "./App.scss";
// import "./assets/appReady.wav";

export default function App() {
  const [commands, setCommands] = useState([]);
  const [visible, setVisible] = useState(false);
  const [boardState, setBoardState] = useState("hidden");
  // "hidden" | "entering" | "visible" | "exiting"

  const COLORS = [
    "#e82236",
    "#9d090c",
    "#1b0505",
    "#8599ac",
    "#e4eeed",
    "#ffffff",
    "#fcee20",
  ];

  function getTextColor(backgroundColor) {
    const hex = backgroundColor.replace("#", "");

    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);

    const luminance = 0.299 * r + 0.587 * g + 0.114 * b;

    return luminance > 186 ? "#000000" : "#ffffff";
  }

  useEffect(() => {
    window.api.onAppReady(() => {
      console.log("app ready");
      const audio = new Audio(appReadySound);
      audio.volume = 0.1;
      audio.play();
    });
  }, []);

  window.api.getCommands().then((cmds) => {
    const colored = cmds.map((cmd, i) => {
      const bg = COLORS[i % COLORS.length];

      return {
        ...cmd,
        color: bg,
        textColor: getTextColor(bg),
      };
    });

    setCommands(colored);
  });

  useEffect(() => {
    const unsubscribe = window.api.onDashboardVisible((visible) => {
      if (visible) {
        setBoardState("entering");

        requestAnimationFrame(() => {
          setBoardState("visible");
        });
      } else {
        setBoardState("exiting");

        setTimeout(() => {
          setBoardState("hidden");
        }, 180);
      }
    });

    return unsubscribe;
  }, []);

  return (
    <div className={`board ${boardState}`}>
      <div className="honeycomb">
        {commands.map((cmd) => (
          <div
            key={cmd.id}
            className="cell"
            onClick={() => window.api.runCommand(cmd.id)}
            style={{
              backgroundColor: cmd.color,
              left: cmd.x,
              top: cmd.y,
            }}
          >
            <h3
              style={{
                color: cmd.textColor,
                background: "transparent",
                border: "none",
              }}
            >
              {cmd.name}
            </h3>
            {/* <h3 style={{ color: cmd.textColor }}>{cmd.shortcut}</h3> */}
          </div>
        ))}
      </div>
    </div>
  );
}
