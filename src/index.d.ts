import Roact from "@rbxts/roact";

type HistoryId = string | number;

// Adapters
declare namespace RoactWM {
        export function Adapter(
                callback: (history: History) => void
        ): void;

        export type ComponentAdapter = Roact.ComponentConstructor<{
                render: (history: History) => Roact.Element
        }>;
        export const ComponentAdapter: ComponentAdapter;
}

// Window
declare namespace RoactWM {
        export interface WindowProperties extends Roact.JsxInstance<Frame> {
                Id: HistoryId;
                OnOpen?: (history: History) => void;
                OnClosed?: (history: History) => void;
                OnFocused?: (history: History) => void;
                OnFocusReleased?: (history: History) => void;
                FocusGui?: Roact.Ref<GuiObject>;
        }

        export type Window = Roact.ComponentConstructor<WindowProperties>;
        export const Window: Window;
}

// History
declare namespace RoactWM {
        export interface History {
                from(history: History): History;
                get(): Array<HistoryId>;
                set(newHistory: Array<HistoryId>): void;
                has(value: HistoryId): boolean;
                push(value: HistoryId): void;
                remove(value: HistoryId): void;
                index(value: HistoryId): number;
                clear(): void;
                size(): number;
                latest(): HistoryId;
                latestIs(value: HistoryId): boolean;
        }
}

export = RoactWM;