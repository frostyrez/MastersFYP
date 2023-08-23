# Predictive Control of Autonomous Quadcopters

## Background

As quadcopters become increasingly present in urban environments, the level of safety of UAS demanded by the public equally increases. Of increasing interest is the subject of fully robust, autonomous quadcopters. Indeed there is immense value in a quadcopter software that can get from point A to point B while taking into account dynamic constraints imposed upon it by both the environment and its inherent physics. How can one design a quadcopter controller that can deal with the loss of one its rotors, a heavy gust of wind, and an incoming aerial object simultaneously and autonomously?

In my paper I explore reasons why existing controller methods (such as PID, LQR, and MRAC) are unsuited for this kind of situation, and that an emerging control theory called Model Predictive Control (MPC) is much more suitable. MPC is an optimal control technique that sends control inputs (i.e. motor voltages) within a set of constraints (e.g. voltage limits) to minimise a cost function (e.g. distance from goal). At each timestep, control inputs over a control horizon are predicted, from which the quadcopter's future state (and therefore cost function) is predicted over a prediction horizon. The control horizon and prediction horizon need to be tuned to the specific situation but there is often optimal balance between computational time and stability.
<p align="center">
<img width="729" alt="image" src="https://github.com/frostyrez/MastersFYP/assets/123249055/1c85eac2-a308-4106-8079-ae44ee79a3ee">
</p>
<p align="center">
_LQR vs MPC Control Diagrams_
</p>

## Controller in action



<p align="center">
![clean](https://github.com/frostyrez/MastersFYP/assets/123249055/45734f6a-0e26-4629-b593-8b0c182555bd)
</p>
<p align="center">
_Quadcopter responding to a step change in position demand from (0,0,0) to (2,2,2) at t = 1s._
</p>
To account for various failure cases such as complete rotor failure, various MPC controllers are linked in parallel that are each tuned for a particular set of rotor dynamics. At each timestep, the control input sent to the quadcopter model is also sent to each of the controllers, and the resulting state of the quadcopter is compared to what each of the controllers "think" the quadcopter's state is. For example, if rotor 3 fails, then the controller that has been specifically tuned around the dynamics of a three-rotored drone will have the most accurate prediction of the quadcopter's state following that control input. This controller will then become the active controller, until another controller predicts the quadcopter's state more accurately (accounting for subsequent failures).

As you can see in the animation below, once the rotor is lost, the active controller is changed, and the drone stabilises. Otherwise, the rotor would have continued spinning out of control.
<p align="center">
![failure](https://github.com/frostyrez/MastersFYP/assets/123249055/1fed635f-4a16-4694-ab55-4efb3bb3bdea)
</p>
<p align="center">
_Quadcopter responding to two changes in position demand: (0,0,10) at t = 1s, and (0,0,20) at t = 10s, with complete loss of rotor 1 at t = 11s. The active controller quickly_
</p>

## Code 

Some of the code used in this project is shown here.

A dynamic version of the A* path-finding algorithm is used in conjunction with the Multiple-MPC method.
