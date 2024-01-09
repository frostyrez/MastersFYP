# Predictive Control of Autonomous Quadcopters

## Background

As quadcopters become increasingly present in urban environments, the level of safety of Unmanned Aerial Systems (UAS) such as drones demanded by the public equally increases. It is of no surprise then that the topic of fully robust, autonomous quadcopters is becoming ever more relevant. Indeed there is immense value in quadcopter software that can get from point A to point B while taking into account dynamic constraints. How can one design a quadcopter controller that can deal with the loss of one its rotors, a heavy gust of wind, and an incoming aerial object simultaneously and autonomously?

In my paper (attached), I explore reasons why existing quadcopter controller methods (such as PID, LQR, and MRAC) are unsuited for this kind of situation, and that an emerging control theory called Model Predictive Control (MPC) is much more suitable. MPC is an optimal control technique that sends control inputs (motor voltages) within a set of constraints (voltage limits, rotor speeds) to minimise a cost function (distance from goal). At each timestep, control inputs over a control horizon are predicted, from which the quadcopter's future state (and therefore cost function) is predicted over a prediction horizon. The control horizon and prediction horizon need to be tuned to the specific situation but there often exists some optimal trade-off between computational time and control stability.
<p align="center">
<img width="729" alt="image" src="https://github.com/frostyrez/MastersFYP/assets/123249055/1c85eac2-a308-4106-8079-ae44ee79a3ee">
</p>
<p align="center">
  <i>LQR vs MPC Control Diagrams, two popular drone control methods</i>
</p>

## Descriptions of Key Scripts

`nlmpc_init.m`:
This script is an alternative to the Simulink code block representation covering the quadcopter model, the controller, and associated feedback loops. Although the high-level closed-loop control is not as immediately obvious here as in the Simulink representation, configuring lower-level parameters of the controller such as weight matrices and horizons is made easier in this format.

Similarly to how a neural network might be configured, a non-linear MPC object is first initialised (line 6), before declaring various properties of the object, such as the quadrotor's state function, timestep, prediction and control horizons, and target state weights (lines 7-27):

```
nlobj = nlmpc(nx=16,ny=16,nu=4);
nlobj.Model.StateFcn = "nlStateFcn";
nlobj.Weights.OutputVariables = zeros(1,16);
nlobj.Weights.OutputVariables(7:9) = 10;
nlobj.Weights.ManipulatedVariables(1:4) = .1;
nlobj.Weights.ManipulatedVariablesRate(1:4) = 0;

nlobj.Optimization.SolverOptions.MaxIterations = 50;
nlobj.Ts = .01;
nlobj.PredictionHorizon = 200;
nlobj.ControlHorizon = 50;
nlobj.MV = struct('Min',{-6.176;-6.176;-6.176;-6.176},...
    'Max',{8.624;8.624;8.624;8.624});
nlobj.Optimization.UseSuboptimalSolution = true;
```

Once the simulation properties are set (lines 29-33), the simulation is ran within a for loop (lines 34-48).

<p align="center">
  ------------------------------------------------------------------------
</p>

`Lineared_SS_model.m`:

The initial quadcopter's states are linearised around a hovering state and defined as a matrix below. The 16 states correspond to position on the x, y, and z axes, velocity in those 3 dimensions, rotational position, rotational velocity, and rotor speeds. The steady-state equations below are then continuously solved at each timestep:

$$\dot{x} = Ax + Bu$$
  
$$y = Cx + Du$$

Where $x$ is a 16x1 vector representing the quadcopter's states, $A$ is a 16x16 state space matrix relating the quadcopter's states to its derivative states, $u$ is a 4x1 vector of the control inputs (motor voltages), and $B$ is a matrix relating the motor voltages to the future states of the quadcopter.

### A Note on the Similarities Between Control Theory and AI

It should be noted that the equations and calculations listed above are indeed based on the same principles of linear algebra and matrix manipulation that form the foundation of neural network theory. The convolution, pooling and flattening of tensors is built upon the same fundamentical mathematical principles as the control equations linking states, gains, and control inputs. Matrix $B$ from the state-space equation is shown here, where it serves a similar role to the biases in the activation matrices in neural networks. Each input $V1$ - $V4$ has a varied impact on the output nodes: for example, rotor voltage 1 $V1$ has a strong effect on the rotational speed of rotor 1 $\omega_1$. However, the other rotor speeds and the rotational speed of the drone itself are also slightly influenced by this control input because of the torque that the rotor is applying to the entire system.

|        | **V1**  | **V2**  | **V3**  | **V4**  |
|--------|---------|---------|---------|---------|
| **u**  | 0       | 0       | 0       | 0       |
| **v**  | 0       | 0       | 0       | 0       |
| **w**  | 0       | 0       | 0       | 0       |
| **p**  | 0       | 0       | 0       | 0       |
| **q**  | 0       | 0       | 0       | 0       |
| **r**  | -0.4459 | 0.4459  | -0.4459 | 0.4459  |
| **x**  | 0       | 0       | 0       | 0       |
| **y**  | 0       | 0       | 0       | 0       |
| **z**  | 0       | 0       | 0       | 0       |
| **ϕ**  | 0       | 0       | 0       | 0       |
| **θ**  | 0       | 0       | 0       | 0       |
| **ψ**  | 0       | 0       | 0       | 0       |
| **ω1** | 62.1542 | -0.4459 | 0.4459  | -0.4459 |
| **ω2** | -0.4459 | 62.1542 | -0.4459 | 0.4459  |
| **ω3** | 0.4459  | -0.4459 | 62.1542 | -0.4459 |
| **ω4** | -0.4459 | 0.4459  | -0.4459 | 62.1542 |

<i> Matrix $B$ in the State-Space Equation </i>

## Controller in action
<p align="center">
  <img src="https://github.com/frostyrez/MastersFYP/blob/main/clean.gif" />
</p>
<p align="center">
  <i> Quadcopter responding to a step change in position demand from (0,0,0) to (2,2,2) at t = 1s. </i>
</p>

To account for various failure cases such as complete rotor failure, various MPC controllers are linked in parallel that are each tuned for a particular set of rotor dynamics. At each timestep, the control input sent to the quadcopter model is also sent to each of the controllers, and the resulting state of the quadcopter is compared to what each of the controllers predicted the quadcopter's state would be. For example, if rotor 3 fails, then the controller that has been specifically tuned around the dynamics of a three-rotored drone will have the most accurate prediction of the quadcopter's state following that control input. This controller will then become the active controller, until another controller predicts the quadcopter's state more accurately.

<p align="center">
<img width="543" alt="mult_mpc_diag" src="https://github.com/frostyrez/MastersFYP/assets/123249055/dbeff25f-ba83-4d8b-b238-d92bc2d706b3">
</p>
<p align="center">
  <i>Multiple MPC Control Diagram (System of systems approach)</i>
</p>

As you can see in the animation below, once the rotor is lost, the active controller is changed from `Act CTR = 1` to `Act CTR = 2`, and the drone stabilises. Otherwise, the rotor would have continued spinning out of control.

<p align="center">
  <img src="https://github.com/frostyrez/MastersFYP/blob/main/robust.gif" />

</p>

<p align="center">
  <i>Quadcopter responding to two changes in position demand: (0,0,10) at t = 1s, and (0,0,20) at t = 10s, with complete loss of rotor 1 at t = 11s.</i>
</p>

